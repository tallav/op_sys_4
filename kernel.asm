
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
80100044:	bb 14 db 10 80       	mov    $0x8010db14,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 86 10 80       	push   $0x80108600
80100051:	68 e0 da 10 80       	push   $0x8010dae0
80100056:	e8 c5 58 00 00       	call   80105920 <initlock>
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
80100092:	68 07 86 10 80       	push   $0x80108607
80100097:	50                   	push   %eax
80100098:	e8 53 57 00 00       	call   801057f0 <initsleeplock>
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
801000e4:	e8 77 59 00 00       	call   80105a60 <acquire>
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
80100162:	e8 b9 59 00 00       	call   80105b20 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 56 00 00       	call   80105830 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 5d 22 00 00       	call   801023e0 <iderw>
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
80100193:	68 0e 86 10 80       	push   $0x8010860e
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
801001ae:	e8 1d 57 00 00       	call   801058d0 <holdingsleep>
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
801001c4:	e9 17 22 00 00       	jmp    801023e0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 86 10 80       	push   $0x8010861f
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
801001ef:	e8 dc 56 00 00       	call   801058d0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 56 00 00       	call   80105890 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 da 10 80 	movl   $0x8010dae0,(%esp)
8010020b:	e8 50 58 00 00       	call   80105a60 <acquire>
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
8010025c:	e9 bf 58 00 00       	jmp    80105b20 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 86 10 80       	push   $0x80108626
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
80100285:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028c:	e8 cf 57 00 00       	call   80105a60 <acquire>
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
801002c5:	e8 66 3e 00 00       	call   80104130 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 24 11 80    	mov    0x801124c0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 24 11 80    	cmp    0x801124c4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 b0 38 00 00       	call   80103b90 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 c5 10 80       	push   $0x8010c520
801002ef:	e8 2c 58 00 00       	call   80105b20 <release>
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
8010034d:	e8 ce 57 00 00       	call   80105b20 <release>
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
801003a9:	e8 22 27 00 00       	call   80102ad0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 2d 86 10 80       	push   $0x8010862d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 d3 91 10 80 	movl   $0x801091d3,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 63 55 00 00       	call   80105940 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 41 86 10 80       	push   $0x80108641
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
8010043a:	e8 c1 6d 00 00       	call   80107200 <uartputc>
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
801004ec:	e8 0f 6d 00 00       	call   80107200 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 03 6d 00 00       	call   80107200 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 f7 6c 00 00       	call   80107200 <uartputc>
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
80100524:	e8 f7 56 00 00       	call   80105c20 <memmove>
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
80100541:	e8 2a 56 00 00       	call   80105b70 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 45 86 10 80       	push   $0x80108645
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
801005b1:	0f b6 92 70 86 10 80 	movzbl -0x7fef7990(%edx),%edx
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
80100614:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010061b:	e8 40 54 00 00       	call   80105a60 <acquire>
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
80100647:	e8 d4 54 00 00       	call   80105b20 <release>
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
8010071f:	e8 fc 53 00 00       	call   80105b20 <release>
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
801007d0:	ba 58 86 10 80       	mov    $0x80108658,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 c5 10 80       	push   $0x8010c520
801007f0:	e8 6b 52 00 00       	call   80105a60 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 5f 86 10 80       	push   $0x8010865f
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
80100823:	e8 38 52 00 00       	call   80105a60 <acquire>
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
80100888:	e8 93 52 00 00       	call   80105b20 <release>
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
80100997:	e9 24 3a 00 00       	jmp    801043c0 <procdump>
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
801009c6:	68 68 86 10 80       	push   $0x80108668
801009cb:	68 20 c5 10 80       	push   $0x8010c520
801009d0:	e8 4b 4f 00 00       	call   80105920 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 9c 2e 11 80 00 	movl   $0x80100600,0x80112e9c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 98 2e 11 80 70 	movl   $0x80100270,0x80112e98
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
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
80100a94:	e8 b7 78 00 00       	call   80108350 <setupkvm>
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
80100af6:	e8 75 76 00 00       	call   80108170 <allocuvm>
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
80100b28:	e8 83 75 00 00       	call   801080b0 <loaduvm>
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
80100b72:	e8 59 77 00 00       	call   801082d0 <freevm>
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
80100baa:	e8 c1 75 00 00       	call   80108170 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 0a 77 00 00       	call   801082d0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 d8 23 00 00       	call   80102fb0 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 81 86 10 80       	push   $0x80108681
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
80100c06:	e8 e5 77 00 00       	call   801083f0 <clearpteu>
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
80100c39:	e8 52 51 00 00       	call   80105d90 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 3f 51 00 00       	call   80105d90 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 ee 78 00 00       	call   80108550 <copyout>
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
80100cc7:	e8 84 78 00 00       	call   80108550 <copyout>
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
80100d0a:	e8 41 50 00 00       	call   80105d50 <safestrcpy>
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
80100d34:	e8 e7 71 00 00       	call   80107f20 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 8f 75 00 00       	call   801082d0 <freevm>
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
80100d66:	68 8d 86 10 80       	push   $0x8010868d
80100d6b:	68 e0 24 11 80       	push   $0x801124e0
80100d70:	e8 ab 4b 00 00       	call   80105920 <initlock>
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
80100d84:	bb 14 25 11 80       	mov    $0x80112514,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 e0 24 11 80       	push   $0x801124e0
80100d91:	e8 ca 4c 00 00       	call   80105a60 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 74 2e 11 80    	cmp    $0x80112e74,%ebx
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
80100dbc:	68 e0 24 11 80       	push   $0x801124e0
80100dc1:	e8 5a 4d 00 00       	call   80105b20 <release>
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
80100dd5:	68 e0 24 11 80       	push   $0x801124e0
80100dda:	e8 41 4d 00 00       	call   80105b20 <release>
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
80100dfa:	68 e0 24 11 80       	push   $0x801124e0
80100dff:	e8 5c 4c 00 00       	call   80105a60 <acquire>
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
80100e17:	68 e0 24 11 80       	push   $0x801124e0
80100e1c:	e8 ff 4c 00 00       	call   80105b20 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 94 86 10 80       	push   $0x80108694
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
80100e4c:	68 e0 24 11 80       	push   $0x801124e0
80100e51:	e8 0a 4c 00 00       	call   80105a60 <acquire>
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
80100e6e:	c7 45 08 e0 24 11 80 	movl   $0x801124e0,0x8(%ebp)
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
80100e7c:	e9 9f 4c 00 00       	jmp    80105b20 <release>
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
80100ea0:	68 e0 24 11 80       	push   $0x801124e0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 73 4c 00 00       	call   80105b20 <release>
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
80100f02:	68 9c 86 10 80       	push   $0x8010869c
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
80100fe2:	68 a6 86 10 80       	push   $0x801086a6
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
801010f5:	68 af 86 10 80       	push   $0x801086af
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 b5 86 10 80       	push   $0x801086b5
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
80101119:	68 e0 24 11 80       	push   $0x801124e0
8010111e:	e8 3d 49 00 00       	call   80105a60 <acquire>
80101123:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101126:	ba 14 25 11 80       	mov    $0x80112514,%edx
8010112b:	90                   	nop
8010112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(f->ref == 0){
      counter++;
80101130:	83 7a 04 01          	cmpl   $0x1,0x4(%edx)
80101134:	83 d3 00             	adc    $0x0,%ebx
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101137:	83 c2 18             	add    $0x18,%edx
8010113a:	81 fa 74 2e 11 80    	cmp    $0x80112e74,%edx
80101140:	72 ee                	jb     80101130 <get_free_fds+0x20>
    }
  }
  release(&ftable.lock);
80101142:	83 ec 0c             	sub    $0xc,%esp
80101145:	68 e0 24 11 80       	push   $0x801124e0
8010114a:	e8 d1 49 00 00       	call   80105b20 <release>
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
80101179:	68 e0 24 11 80       	push   $0x801124e0
8010117e:	e8 dd 48 00 00       	call   80105a60 <acquire>
80101183:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101186:	ba 14 25 11 80       	mov    $0x80112514,%edx
8010118b:	90                   	nop
8010118c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(f->writable){
      counter++;
80101190:	80 7a 09 01          	cmpb   $0x1,0x9(%edx)
80101194:	83 db ff             	sbb    $0xffffffff,%ebx
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101197:	83 c2 18             	add    $0x18,%edx
8010119a:	81 fa 74 2e 11 80    	cmp    $0x80112e74,%edx
801011a0:	72 ee                	jb     80101190 <get_writeable_fds+0x20>
    }
  }
  release(&ftable.lock);
801011a2:	83 ec 0c             	sub    $0xc,%esp
801011a5:	68 e0 24 11 80       	push   $0x801124e0
801011aa:	e8 71 49 00 00       	call   80105b20 <release>
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
801011c9:	68 e0 24 11 80       	push   $0x801124e0
801011ce:	e8 8d 48 00 00       	call   80105a60 <acquire>
801011d3:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011d6:	ba 14 25 11 80       	mov    $0x80112514,%edx
801011db:	90                   	nop
801011dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(f->readable){
      counter++;
801011e0:	80 7a 08 01          	cmpb   $0x1,0x8(%edx)
801011e4:	83 db ff             	sbb    $0xffffffff,%ebx
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011e7:	83 c2 18             	add    $0x18,%edx
801011ea:	81 fa 74 2e 11 80    	cmp    $0x80112e74,%edx
801011f0:	72 ee                	jb     801011e0 <get_readable_fds+0x20>
    }
  }
  release(&ftable.lock);
801011f2:	83 ec 0c             	sub    $0xc,%esp
801011f5:	68 e0 24 11 80       	push   $0x801124e0
801011fa:	e8 21 49 00 00       	call   80105b20 <release>
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
80101219:	68 e0 24 11 80       	push   $0x801124e0
8010121e:	e8 3d 48 00 00       	call   80105a60 <acquire>
80101223:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101226:	ba 14 25 11 80       	mov    $0x80112514,%edx
8010122b:	90                   	nop
8010122c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    counter = counter + f->ref;
80101230:	03 5a 04             	add    0x4(%edx),%ebx
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101233:	83 c2 18             	add    $0x18,%edx
80101236:	81 fa 74 2e 11 80    	cmp    $0x80112e74,%edx
8010123c:	72 f2                	jb     80101230 <get_total_refs+0x20>
  }
  release(&ftable.lock);
8010123e:	83 ec 0c             	sub    $0xc,%esp
80101241:	68 e0 24 11 80       	push   $0x801124e0
80101246:	e8 d5 48 00 00       	call   80105b20 <release>
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
80101269:	68 e0 24 11 80       	push   $0x801124e0
8010126e:	e8 ed 47 00 00       	call   80105a60 <acquire>
80101273:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101276:	ba 14 25 11 80       	mov    $0x80112514,%edx
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
8010128d:	81 fa 74 2e 11 80    	cmp    $0x80112e74,%edx
80101293:	72 eb                	jb     80101280 <get_used_fds+0x20>
    }
  }
  release(&ftable.lock);
80101295:	83 ec 0c             	sub    $0xc,%esp
80101298:	68 e0 24 11 80       	push   $0x801124e0
8010129d:	e8 7e 48 00 00       	call   80105b20 <release>
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
801012b9:	8b 0d 20 2f 11 80    	mov    0x80112f20,%ecx
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
801012dc:	03 05 38 2f 11 80    	add    0x80112f38,%eax
801012e2:	50                   	push   %eax
801012e3:	ff 75 d8             	pushl  -0x28(%ebp)
801012e6:	e8 e5 ed ff ff       	call   801000d0 <bread>
801012eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012ee:	a1 20 2f 11 80       	mov    0x80112f20,%eax
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
80101349:	39 05 20 2f 11 80    	cmp    %eax,0x80112f20
8010134f:	77 80                	ja     801012d1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101351:	83 ec 0c             	sub    $0xc,%esp
80101354:	68 bf 86 10 80       	push   $0x801086bf
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
80101395:	e8 d6 47 00 00       	call   80105b70 <memset>
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
801013ca:	bb 74 2f 11 80       	mov    $0x80112f74,%ebx
{
801013cf:	83 ec 28             	sub    $0x28,%esp
801013d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013d5:	68 40 2f 11 80       	push   $0x80112f40
801013da:	e8 81 46 00 00       	call   80105a60 <acquire>
801013df:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013e5:	eb 17                	jmp    801013fe <iget+0x3e>
801013e7:	89 f6                	mov    %esi,%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801013f0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013f6:	81 fb 94 4b 11 80    	cmp    $0x80114b94,%ebx
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
80101418:	81 fb 94 4b 11 80    	cmp    $0x80114b94,%ebx
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
8010143a:	68 40 2f 11 80       	push   $0x80112f40
8010143f:	e8 dc 46 00 00       	call   80105b20 <release>

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
80101465:	68 40 2f 11 80       	push   $0x80112f40
      ip->ref++;
8010146a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010146d:	e8 ae 46 00 00       	call   80105b20 <release>
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
80101482:	68 d5 86 10 80       	push   $0x801086d5
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
80101557:	68 e5 86 10 80       	push   $0x801086e5
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
80101591:	e8 8a 46 00 00       	call   80105c20 <memmove>
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
801015bc:	68 20 2f 11 80       	push   $0x80112f20
801015c1:	50                   	push   %eax
801015c2:	e8 a9 ff ff ff       	call   80101570 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801015c7:	58                   	pop    %eax
801015c8:	5a                   	pop    %edx
801015c9:	89 da                	mov    %ebx,%edx
801015cb:	c1 ea 0c             	shr    $0xc,%edx
801015ce:	03 15 38 2f 11 80    	add    0x80112f38,%edx
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
80101624:	68 f8 86 10 80       	push   $0x801086f8
80101629:	e8 62 ed ff ff       	call   80100390 <panic>
8010162e:	66 90                	xchg   %ax,%ax

80101630 <iinit>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	53                   	push   %ebx
80101634:	bb 80 2f 11 80       	mov    $0x80112f80,%ebx
80101639:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010163c:	68 0b 87 10 80       	push   $0x8010870b
80101641:	68 40 2f 11 80       	push   $0x80112f40
80101646:	e8 d5 42 00 00       	call   80105920 <initlock>
8010164b:	83 c4 10             	add    $0x10,%esp
8010164e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101650:	83 ec 08             	sub    $0x8,%esp
80101653:	68 12 87 10 80       	push   $0x80108712
80101658:	53                   	push   %ebx
80101659:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010165f:	e8 8c 41 00 00       	call   801057f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101664:	83 c4 10             	add    $0x10,%esp
80101667:	81 fb a0 4b 11 80    	cmp    $0x80114ba0,%ebx
8010166d:	75 e1                	jne    80101650 <iinit+0x20>
  readsb(dev, &sb);
8010166f:	83 ec 08             	sub    $0x8,%esp
80101672:	68 20 2f 11 80       	push   $0x80112f20
80101677:	ff 75 08             	pushl  0x8(%ebp)
8010167a:	e8 f1 fe ff ff       	call   80101570 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010167f:	ff 35 38 2f 11 80    	pushl  0x80112f38
80101685:	ff 35 34 2f 11 80    	pushl  0x80112f34
8010168b:	ff 35 30 2f 11 80    	pushl  0x80112f30
80101691:	ff 35 2c 2f 11 80    	pushl  0x80112f2c
80101697:	ff 35 28 2f 11 80    	pushl  0x80112f28
8010169d:	ff 35 24 2f 11 80    	pushl  0x80112f24
801016a3:	ff 35 20 2f 11 80    	pushl  0x80112f20
801016a9:	68 78 87 10 80       	push   $0x80108778
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
801016c9:	83 3d 28 2f 11 80 01 	cmpl   $0x1,0x80112f28
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
801016ff:	39 1d 28 2f 11 80    	cmp    %ebx,0x80112f28
80101705:	76 69                	jbe    80101770 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101707:	89 d8                	mov    %ebx,%eax
80101709:	83 ec 08             	sub    $0x8,%esp
8010170c:	c1 e8 03             	shr    $0x3,%eax
8010170f:	03 05 34 2f 11 80    	add    0x80112f34,%eax
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
8010173e:	e8 2d 44 00 00       	call   80105b70 <memset>
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
80101773:	68 18 87 10 80       	push   $0x80108718
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
80101794:	03 05 34 2f 11 80    	add    0x80112f34,%eax
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
801017e1:	e8 3a 44 00 00       	call   80105c20 <memmove>
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
8010180a:	68 40 2f 11 80       	push   $0x80112f40
8010180f:	e8 4c 42 00 00       	call   80105a60 <acquire>
  ip->ref++;
80101814:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101818:	c7 04 24 40 2f 11 80 	movl   $0x80112f40,(%esp)
8010181f:	e8 fc 42 00 00       	call   80105b20 <release>
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
80101852:	e8 d9 3f 00 00       	call   80105830 <acquiresleep>
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
80101879:	03 05 34 2f 11 80    	add    0x80112f34,%eax
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
801018c8:	e8 53 43 00 00       	call   80105c20 <memmove>
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
801018ed:	68 30 87 10 80       	push   $0x80108730
801018f2:	e8 99 ea ff ff       	call   80100390 <panic>
    panic("ilock");
801018f7:	83 ec 0c             	sub    $0xc,%esp
801018fa:	68 2a 87 10 80       	push   $0x8010872a
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
80101923:	e8 a8 3f 00 00       	call   801058d0 <holdingsleep>
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
8010193f:	e9 4c 3f 00 00       	jmp    80105890 <releasesleep>
    panic("iunlock");
80101944:	83 ec 0c             	sub    $0xc,%esp
80101947:	68 3f 87 10 80       	push   $0x8010873f
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
80101970:	e8 bb 3e 00 00       	call   80105830 <acquiresleep>
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
8010198a:	e8 01 3f 00 00       	call   80105890 <releasesleep>
  acquire(&icache.lock);
8010198f:	c7 04 24 40 2f 11 80 	movl   $0x80112f40,(%esp)
80101996:	e8 c5 40 00 00       	call   80105a60 <acquire>
  ip->ref--;
8010199b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010199f:	83 c4 10             	add    $0x10,%esp
801019a2:	c7 45 08 40 2f 11 80 	movl   $0x80112f40,0x8(%ebp)
}
801019a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019ac:	5b                   	pop    %ebx
801019ad:	5e                   	pop    %esi
801019ae:	5f                   	pop    %edi
801019af:	5d                   	pop    %ebp
  release(&icache.lock);
801019b0:	e9 6b 41 00 00       	jmp    80105b20 <release>
801019b5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801019b8:	83 ec 0c             	sub    $0xc,%esp
801019bb:	68 40 2f 11 80       	push   $0x80112f40
801019c0:	e8 9b 40 00 00       	call   80105a60 <acquire>
    int r = ip->ref;
801019c5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801019c8:	c7 04 24 40 2f 11 80 	movl   $0x80112f40,(%esp)
801019cf:	e8 4c 41 00 00       	call   80105b20 <release>
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
80101bb7:	e8 64 40 00 00       	call   80105c20 <memmove>
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
80101bed:	8b 80 88 2e 11 80    	mov    -0x7feed178(%eax),%eax
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
80101cb3:	e8 68 3f 00 00       	call   80105c20 <memmove>
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
80101cfd:	8b 80 8c 2e 11 80    	mov    -0x7feed174(%eax),%eax
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
80101d4e:	e8 3d 3f 00 00       	call   80105c90 <strncmp>
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
80101d87:	8b 80 80 2e 11 80    	mov    -0x7feed180(%eax),%eax
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
80101dc3:	e8 c8 3e 00 00       	call   80105c90 <strncmp>
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
80101e34:	8b 92 84 2e 11 80    	mov    -0x7feed17c(%edx),%edx
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
80101e53:	68 47 87 10 80       	push   $0x80108747
80101e58:	e8 33 e5 ff ff       	call   80100390 <panic>
      panic("dirlookup read");
80101e5d:	83 ec 0c             	sub    $0xc,%esp
80101e60:	68 59 87 10 80       	push   $0x80108759
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
80101e94:	68 40 2f 11 80       	push   $0x80112f40
80101e99:	e8 c2 3b 00 00       	call   80105a60 <acquire>
  ip->ref++;
80101e9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ea2:	c7 04 24 40 2f 11 80 	movl   $0x80112f40,(%esp)
80101ea9:	e8 72 3c 00 00       	call   80105b20 <release>
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
80101f05:	e8 16 3d 00 00       	call   80105c20 <memmove>
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
80101f4f:	8b 80 80 2e 11 80    	mov    -0x7feed180(%eax),%eax
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
80101fc8:	e8 53 3c 00 00       	call   80105c20 <memmove>
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
801020bd:	e8 2e 3c 00 00       	call   80105cf0 <strncpy>
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
801020fb:	68 68 87 10 80       	push   $0x80108768
80102100:	e8 8b e2 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102105:	83 ec 0c             	sub    $0xc,%esp
80102108:	68 bb 8f 10 80       	push   $0x80108fbb
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
80102154:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010215a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102160 <get_inode_index>:

int
get_inode_index(uint inum)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	56                   	push   %esi
80102164:	53                   	push   %ebx
80102165:	8b 75 08             	mov    0x8(%ebp),%esi
  struct inode *ip;
  int index = -1;
  int i = 0;
80102168:	31 db                	xor    %ebx,%ebx

  acquire(&icache.lock);
8010216a:	83 ec 0c             	sub    $0xc,%esp
8010216d:	68 40 2f 11 80       	push   $0x80112f40
80102172:	e8 e9 38 00 00       	call   80105a60 <acquire>
80102177:	83 c4 10             	add    $0x10,%esp

  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010217a:	ba 74 2f 11 80       	mov    $0x80112f74,%edx
8010217f:	eb 18                	jmp    80102199 <get_inode_index+0x39>
80102181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102188:	81 c2 90 00 00 00    	add    $0x90,%edx
    if(ip->inum == inum){
      index = i;
      release(&icache.lock);
      return index;
    }
    i++;
8010218e:	83 c3 01             	add    $0x1,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102191:	81 fa 94 4b 11 80    	cmp    $0x80114b94,%edx
80102197:	73 27                	jae    801021c0 <get_inode_index+0x60>
    if(ip->inum == inum){
80102199:	39 72 04             	cmp    %esi,0x4(%edx)
8010219c:	75 ea                	jne    80102188 <get_inode_index+0x28>
      release(&icache.lock);
8010219e:	83 ec 0c             	sub    $0xc,%esp
801021a1:	68 40 2f 11 80       	push   $0x80112f40
801021a6:	e8 75 39 00 00       	call   80105b20 <release>
      return index;
801021ab:	83 c4 10             	add    $0x10,%esp
  }
  release(&icache.lock);
  return index;
801021ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021b1:	89 d8                	mov    %ebx,%eax
801021b3:	5b                   	pop    %ebx
801021b4:	5e                   	pop    %esi
801021b5:	5d                   	pop    %ebp
801021b6:	c3                   	ret    
801021b7:	89 f6                	mov    %esi,%esi
801021b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&icache.lock);
801021c0:	83 ec 0c             	sub    $0xc,%esp
  return index;
801021c3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  release(&icache.lock);
801021c8:	68 40 2f 11 80       	push   $0x80112f40
801021cd:	e8 4e 39 00 00       	call   80105b20 <release>
  return index;
801021d2:	83 c4 10             	add    $0x10,%esp
801021d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021d8:	89 d8                	mov    %ebx,%eax
801021da:	5b                   	pop    %ebx
801021db:	5e                   	pop    %esi
801021dc:	5d                   	pop    %ebp
801021dd:	c3                   	ret    
801021de:	66 90                	xchg   %ax,%ax

801021e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	57                   	push   %edi
801021e4:	56                   	push   %esi
801021e5:	53                   	push   %ebx
801021e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801021e9:	85 c0                	test   %eax,%eax
801021eb:	0f 84 b4 00 00 00    	je     801022a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801021f1:	8b 58 08             	mov    0x8(%eax),%ebx
801021f4:	89 c6                	mov    %eax,%esi
801021f6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801021fc:	0f 87 96 00 00 00    	ja     80102298 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102202:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102207:	89 f6                	mov    %esi,%esi
80102209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102210:	89 ca                	mov    %ecx,%edx
80102212:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102213:	83 e0 c0             	and    $0xffffffc0,%eax
80102216:	3c 40                	cmp    $0x40,%al
80102218:	75 f6                	jne    80102210 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010221a:	31 ff                	xor    %edi,%edi
8010221c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102221:	89 f8                	mov    %edi,%eax
80102223:	ee                   	out    %al,(%dx)
80102224:	b8 01 00 00 00       	mov    $0x1,%eax
80102229:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010222e:	ee                   	out    %al,(%dx)
8010222f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102234:	89 d8                	mov    %ebx,%eax
80102236:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102237:	89 d8                	mov    %ebx,%eax
80102239:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010223e:	c1 f8 08             	sar    $0x8,%eax
80102241:	ee                   	out    %al,(%dx)
80102242:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102247:	89 f8                	mov    %edi,%eax
80102249:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010224a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010224e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102253:	c1 e0 04             	shl    $0x4,%eax
80102256:	83 e0 10             	and    $0x10,%eax
80102259:	83 c8 e0             	or     $0xffffffe0,%eax
8010225c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010225d:	f6 06 04             	testb  $0x4,(%esi)
80102260:	75 16                	jne    80102278 <idestart+0x98>
80102262:	b8 20 00 00 00       	mov    $0x20,%eax
80102267:	89 ca                	mov    %ecx,%edx
80102269:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010226a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010226d:	5b                   	pop    %ebx
8010226e:	5e                   	pop    %esi
8010226f:	5f                   	pop    %edi
80102270:	5d                   	pop    %ebp
80102271:	c3                   	ret    
80102272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102278:	b8 30 00 00 00       	mov    $0x30,%eax
8010227d:	89 ca                	mov    %ecx,%edx
8010227f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102280:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102285:	83 c6 5c             	add    $0x5c,%esi
80102288:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010228d:	fc                   	cld    
8010228e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102290:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102293:	5b                   	pop    %ebx
80102294:	5e                   	pop    %esi
80102295:	5f                   	pop    %edi
80102296:	5d                   	pop    %ebp
80102297:	c3                   	ret    
    panic("incorrect blockno");
80102298:	83 ec 0c             	sub    $0xc,%esp
8010229b:	68 d4 87 10 80       	push   $0x801087d4
801022a0:	e8 eb e0 ff ff       	call   80100390 <panic>
    panic("idestart");
801022a5:	83 ec 0c             	sub    $0xc,%esp
801022a8:	68 cb 87 10 80       	push   $0x801087cb
801022ad:	e8 de e0 ff ff       	call   80100390 <panic>
801022b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022c0 <ideinit>:
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801022c6:	68 e6 87 10 80       	push   $0x801087e6
801022cb:	68 80 c9 10 80       	push   $0x8010c980
801022d0:	e8 4b 36 00 00       	call   80105920 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801022d5:	58                   	pop    %eax
801022d6:	a1 60 52 11 80       	mov    0x80115260,%eax
801022db:	5a                   	pop    %edx
801022dc:	83 e8 01             	sub    $0x1,%eax
801022df:	50                   	push   %eax
801022e0:	6a 0e                	push   $0xe
801022e2:	e8 89 03 00 00       	call   80102670 <ioapicenable>
801022e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022ef:	90                   	nop
801022f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022f1:	83 e0 c0             	and    $0xffffffc0,%eax
801022f4:	3c 40                	cmp    $0x40,%al
801022f6:	75 f8                	jne    801022f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801022fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102302:	ee                   	out    %al,(%dx)
80102303:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102308:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010230d:	eb 06                	jmp    80102315 <ideinit+0x55>
8010230f:	90                   	nop
  for(i=0; i<1000; i++){
80102310:	83 e9 01             	sub    $0x1,%ecx
80102313:	74 0f                	je     80102324 <ideinit+0x64>
80102315:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102316:	84 c0                	test   %al,%al
80102318:	74 f6                	je     80102310 <ideinit+0x50>
      havedisk1 = 1;
8010231a:	c7 05 60 c9 10 80 01 	movl   $0x1,0x8010c960
80102321:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102324:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102329:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010232e:	ee                   	out    %al,(%dx)
}
8010232f:	c9                   	leave  
80102330:	c3                   	ret    
80102331:	eb 0d                	jmp    80102340 <ideintr>
80102333:	90                   	nop
80102334:	90                   	nop
80102335:	90                   	nop
80102336:	90                   	nop
80102337:	90                   	nop
80102338:	90                   	nop
80102339:	90                   	nop
8010233a:	90                   	nop
8010233b:	90                   	nop
8010233c:	90                   	nop
8010233d:	90                   	nop
8010233e:	90                   	nop
8010233f:	90                   	nop

80102340 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	57                   	push   %edi
80102344:	56                   	push   %esi
80102345:	53                   	push   %ebx
80102346:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102349:	68 80 c9 10 80       	push   $0x8010c980
8010234e:	e8 0d 37 00 00       	call   80105a60 <acquire>

  if((b = idequeue) == 0){
80102353:	8b 1d 64 c9 10 80    	mov    0x8010c964,%ebx
80102359:	83 c4 10             	add    $0x10,%esp
8010235c:	85 db                	test   %ebx,%ebx
8010235e:	74 67                	je     801023c7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102360:	8b 43 58             	mov    0x58(%ebx),%eax
80102363:	a3 64 c9 10 80       	mov    %eax,0x8010c964

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102368:	8b 3b                	mov    (%ebx),%edi
8010236a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102370:	75 31                	jne    801023a3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102372:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102377:	89 f6                	mov    %esi,%esi
80102379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102380:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102381:	89 c6                	mov    %eax,%esi
80102383:	83 e6 c0             	and    $0xffffffc0,%esi
80102386:	89 f1                	mov    %esi,%ecx
80102388:	80 f9 40             	cmp    $0x40,%cl
8010238b:	75 f3                	jne    80102380 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010238d:	a8 21                	test   $0x21,%al
8010238f:	75 12                	jne    801023a3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102391:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102394:	b9 80 00 00 00       	mov    $0x80,%ecx
80102399:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010239e:	fc                   	cld    
8010239f:	f3 6d                	rep insl (%dx),%es:(%edi)
801023a1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801023a3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801023a6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801023a9:	89 f9                	mov    %edi,%ecx
801023ab:	83 c9 02             	or     $0x2,%ecx
801023ae:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801023b0:	53                   	push   %ebx
801023b1:	e8 2a 1f 00 00       	call   801042e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801023b6:	a1 64 c9 10 80       	mov    0x8010c964,%eax
801023bb:	83 c4 10             	add    $0x10,%esp
801023be:	85 c0                	test   %eax,%eax
801023c0:	74 05                	je     801023c7 <ideintr+0x87>
    idestart(idequeue);
801023c2:	e8 19 fe ff ff       	call   801021e0 <idestart>
    release(&idelock);
801023c7:	83 ec 0c             	sub    $0xc,%esp
801023ca:	68 80 c9 10 80       	push   $0x8010c980
801023cf:	e8 4c 37 00 00       	call   80105b20 <release>

  release(&idelock);
}
801023d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023d7:	5b                   	pop    %ebx
801023d8:	5e                   	pop    %esi
801023d9:	5f                   	pop    %edi
801023da:	5d                   	pop    %ebp
801023db:	c3                   	ret    
801023dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	53                   	push   %ebx
801023e4:	83 ec 10             	sub    $0x10,%esp
801023e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801023ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801023ed:	50                   	push   %eax
801023ee:	e8 dd 34 00 00       	call   801058d0 <holdingsleep>
801023f3:	83 c4 10             	add    $0x10,%esp
801023f6:	85 c0                	test   %eax,%eax
801023f8:	0f 84 c6 00 00 00    	je     801024c4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023fe:	8b 03                	mov    (%ebx),%eax
80102400:	83 e0 06             	and    $0x6,%eax
80102403:	83 f8 02             	cmp    $0x2,%eax
80102406:	0f 84 ab 00 00 00    	je     801024b7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010240c:	8b 53 04             	mov    0x4(%ebx),%edx
8010240f:	85 d2                	test   %edx,%edx
80102411:	74 0d                	je     80102420 <iderw+0x40>
80102413:	a1 60 c9 10 80       	mov    0x8010c960,%eax
80102418:	85 c0                	test   %eax,%eax
8010241a:	0f 84 b1 00 00 00    	je     801024d1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102420:	83 ec 0c             	sub    $0xc,%esp
80102423:	68 80 c9 10 80       	push   $0x8010c980
80102428:	e8 33 36 00 00       	call   80105a60 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010242d:	8b 15 64 c9 10 80    	mov    0x8010c964,%edx
80102433:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102436:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010243d:	85 d2                	test   %edx,%edx
8010243f:	75 09                	jne    8010244a <iderw+0x6a>
80102441:	eb 6d                	jmp    801024b0 <iderw+0xd0>
80102443:	90                   	nop
80102444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102448:	89 c2                	mov    %eax,%edx
8010244a:	8b 42 58             	mov    0x58(%edx),%eax
8010244d:	85 c0                	test   %eax,%eax
8010244f:	75 f7                	jne    80102448 <iderw+0x68>
80102451:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102454:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102456:	39 1d 64 c9 10 80    	cmp    %ebx,0x8010c964
8010245c:	74 42                	je     801024a0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010245e:	8b 03                	mov    (%ebx),%eax
80102460:	83 e0 06             	and    $0x6,%eax
80102463:	83 f8 02             	cmp    $0x2,%eax
80102466:	74 23                	je     8010248b <iderw+0xab>
80102468:	90                   	nop
80102469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102470:	83 ec 08             	sub    $0x8,%esp
80102473:	68 80 c9 10 80       	push   $0x8010c980
80102478:	53                   	push   %ebx
80102479:	e8 b2 1c 00 00       	call   80104130 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010247e:	8b 03                	mov    (%ebx),%eax
80102480:	83 c4 10             	add    $0x10,%esp
80102483:	83 e0 06             	and    $0x6,%eax
80102486:	83 f8 02             	cmp    $0x2,%eax
80102489:	75 e5                	jne    80102470 <iderw+0x90>
  }

  release(&idelock);
8010248b:	c7 45 08 80 c9 10 80 	movl   $0x8010c980,0x8(%ebp)
}
80102492:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102495:	c9                   	leave  
  release(&idelock);
80102496:	e9 85 36 00 00       	jmp    80105b20 <release>
8010249b:	90                   	nop
8010249c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801024a0:	89 d8                	mov    %ebx,%eax
801024a2:	e8 39 fd ff ff       	call   801021e0 <idestart>
801024a7:	eb b5                	jmp    8010245e <iderw+0x7e>
801024a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024b0:	ba 64 c9 10 80       	mov    $0x8010c964,%edx
801024b5:	eb 9d                	jmp    80102454 <iderw+0x74>
    panic("iderw: nothing to do");
801024b7:	83 ec 0c             	sub    $0xc,%esp
801024ba:	68 00 88 10 80       	push   $0x80108800
801024bf:	e8 cc de ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801024c4:	83 ec 0c             	sub    $0xc,%esp
801024c7:	68 ea 87 10 80       	push   $0x801087ea
801024cc:	e8 bf de ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801024d1:	83 ec 0c             	sub    $0xc,%esp
801024d4:	68 15 88 10 80       	push   $0x80108815
801024d9:	e8 b2 de ff ff       	call   80100390 <panic>
801024de:	66 90                	xchg   %ax,%ax

801024e0 <get_read_wait_ops>:
}

// TODO: 
int
get_read_wait_ops(void)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	53                   	push   %ebx
  int counter = 0;
801024e4:	31 db                	xor    %ebx,%ebx
{
801024e6:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  acquire(&idelock);
801024e9:	68 80 c9 10 80       	push   $0x8010c980
801024ee:	e8 6d 35 00 00       	call   80105a60 <acquire>
  for(b = idequeue; b != 0; b = b->qnext){
801024f3:	8b 15 64 c9 10 80    	mov    0x8010c964,%edx
801024f9:	83 c4 10             	add    $0x10,%esp
801024fc:	85 d2                	test   %edx,%edx
801024fe:	74 12                	je     80102512 <get_read_wait_ops+0x32>
    if(!(b->flags & B_VALID)){ // B_VALID bit is off - waiting to read
80102500:	8b 0a                	mov    (%edx),%ecx
  for(b = idequeue; b != 0; b = b->qnext){
80102502:	8b 52 58             	mov    0x58(%edx),%edx
    if(!(b->flags & B_VALID)){ // B_VALID bit is off - waiting to read
80102505:	83 e1 02             	and    $0x2,%ecx
      counter++;
80102508:	83 f9 01             	cmp    $0x1,%ecx
8010250b:	83 d3 00             	adc    $0x0,%ebx
  for(b = idequeue; b != 0; b = b->qnext){
8010250e:	85 d2                	test   %edx,%edx
80102510:	75 ee                	jne    80102500 <get_read_wait_ops+0x20>
    }
  }
  release(&idelock);
80102512:	83 ec 0c             	sub    $0xc,%esp
80102515:	68 80 c9 10 80       	push   $0x8010c980
8010251a:	e8 01 36 00 00       	call   80105b20 <release>
  return counter;
}
8010251f:	89 d8                	mov    %ebx,%eax
80102521:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102524:	c9                   	leave  
80102525:	c3                   	ret    
80102526:	8d 76 00             	lea    0x0(%esi),%esi
80102529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102530 <get_waiting_ops>:
{
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	53                   	push   %ebx
80102534:	83 ec 04             	sub    $0x4,%esp
  return get_read_wait_ops() + get_write_wait_ops();
80102537:	e8 a4 ff ff ff       	call   801024e0 <get_read_wait_ops>
8010253c:	89 c3                	mov    %eax,%ebx
8010253e:	e8 9d ff ff ff       	call   801024e0 <get_read_wait_ops>
}
80102543:	83 c4 04             	add    $0x4,%esp
  return get_read_wait_ops() + get_write_wait_ops();
80102546:	01 d8                	add    %ebx,%eax
}
80102548:	5b                   	pop    %ebx
80102549:	5d                   	pop    %ebp
8010254a:	c3                   	ret    
8010254b:	90                   	nop
8010254c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102550 <get_write_wait_ops>:
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	5d                   	pop    %ebp
80102554:	eb 8a                	jmp    801024e0 <get_read_wait_ops>
80102556:	8d 76 00             	lea    0x0(%esi),%esi
80102559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102560 <get_working_blocks>:

uint currQueue[256] = {0};

uint *
get_working_blocks(void)
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	83 ec 14             	sub    $0x14,%esp
  int i = 0;
  struct buf *b;

  acquire(&idelock);
80102566:	68 80 c9 10 80       	push   $0x8010c980
8010256b:	e8 f0 34 00 00       	call   80105a60 <acquire>
  for(b = idequeue; b != 0; b = b->qnext){
80102570:	a1 64 c9 10 80       	mov    0x8010c964,%eax
80102575:	83 c4 10             	add    $0x10,%esp
80102578:	85 c0                	test   %eax,%eax
8010257a:	74 22                	je     8010259e <get_working_blocks+0x3e>
8010257c:	ba 60 c5 10 80       	mov    $0x8010c560,%edx
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    currQueue[i] = b->dev;
80102588:	8b 48 04             	mov    0x4(%eax),%ecx
8010258b:	83 c2 08             	add    $0x8,%edx
8010258e:	89 4a f8             	mov    %ecx,-0x8(%edx)
    currQueue[i+1] = b->blockno;
80102591:	8b 48 08             	mov    0x8(%eax),%ecx
80102594:	89 4a fc             	mov    %ecx,-0x4(%edx)
  for(b = idequeue; b != 0; b = b->qnext){
80102597:	8b 40 58             	mov    0x58(%eax),%eax
8010259a:	85 c0                	test   %eax,%eax
8010259c:	75 ea                	jne    80102588 <get_working_blocks+0x28>
    i = i+2;
  }
  release(&idelock);
8010259e:	83 ec 0c             	sub    $0xc,%esp
801025a1:	68 80 c9 10 80       	push   $0x8010c980
801025a6:	e8 75 35 00 00       	call   80105b20 <release>

  return currQueue;
}
801025ab:	b8 60 c5 10 80       	mov    $0x8010c560,%eax
801025b0:	c9                   	leave  
801025b1:	c3                   	ret    
801025b2:	66 90                	xchg   %ax,%ax
801025b4:	66 90                	xchg   %ax,%ax
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
801025c1:	c7 05 94 4b 11 80 00 	movl   $0xfec00000,0x80114b94
801025c8:	00 c0 fe 
{
801025cb:	89 e5                	mov    %esp,%ebp
801025cd:	56                   	push   %esi
801025ce:	53                   	push   %ebx
  ioapic->reg = reg;
801025cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801025d6:	00 00 00 
  return ioapic->data;
801025d9:	a1 94 4b 11 80       	mov    0x80114b94,%eax
801025de:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801025e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801025e7:	8b 0d 94 4b 11 80    	mov    0x80114b94,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025ed:	0f b6 15 c0 4c 11 80 	movzbl 0x80114cc0,%edx
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
80102607:	68 34 88 10 80       	push   $0x80108834
8010260c:	e8 4f e0 ff ff       	call   80100660 <cprintf>
80102611:	8b 0d 94 4b 11 80    	mov    0x80114b94,%ecx
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
80102632:	8b 0d 94 4b 11 80    	mov    0x80114b94,%ecx

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
80102650:	8b 0d 94 4b 11 80    	mov    0x80114b94,%ecx
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
80102671:	8b 0d 94 4b 11 80    	mov    0x80114b94,%ecx
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
80102685:	8b 0d 94 4b 11 80    	mov    0x80114b94,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010268b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010268e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102691:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102694:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102696:	a1 94 4b 11 80       	mov    0x80114b94,%eax
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
801026c2:	81 fb 48 85 11 80    	cmp    $0x80118548,%ebx
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
801026e2:	e8 89 34 00 00       	call   80105b70 <memset>

  if(kmem.use_lock)
801026e7:	8b 15 d4 4b 11 80    	mov    0x80114bd4,%edx
801026ed:	83 c4 10             	add    $0x10,%esp
801026f0:	85 d2                	test   %edx,%edx
801026f2:	75 2c                	jne    80102720 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801026f4:	a1 d8 4b 11 80       	mov    0x80114bd8,%eax
801026f9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801026fb:	a1 d4 4b 11 80       	mov    0x80114bd4,%eax
  kmem.freelist = r;
80102700:	89 1d d8 4b 11 80    	mov    %ebx,0x80114bd8
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
80102710:	c7 45 08 a0 4b 11 80 	movl   $0x80114ba0,0x8(%ebp)
}
80102717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010271a:	c9                   	leave  
    release(&kmem.lock);
8010271b:	e9 00 34 00 00       	jmp    80105b20 <release>
    acquire(&kmem.lock);
80102720:	83 ec 0c             	sub    $0xc,%esp
80102723:	68 a0 4b 11 80       	push   $0x80114ba0
80102728:	e8 33 33 00 00       	call   80105a60 <acquire>
8010272d:	83 c4 10             	add    $0x10,%esp
80102730:	eb c2                	jmp    801026f4 <kfree+0x44>
    panic("kfree");
80102732:	83 ec 0c             	sub    $0xc,%esp
80102735:	68 66 88 10 80       	push   $0x80108866
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
8010279b:	68 6c 88 10 80       	push   $0x8010886c
801027a0:	68 a0 4b 11 80       	push   $0x80114ba0
801027a5:	e8 76 31 00 00       	call   80105920 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801027aa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027ad:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801027b0:	c7 05 d4 4b 11 80 00 	movl   $0x0,0x80114bd4
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
80102844:	c7 05 d4 4b 11 80 01 	movl   $0x1,0x80114bd4
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
80102860:	a1 d4 4b 11 80       	mov    0x80114bd4,%eax
80102865:	85 c0                	test   %eax,%eax
80102867:	75 1f                	jne    80102888 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102869:	a1 d8 4b 11 80       	mov    0x80114bd8,%eax
  if(r)
8010286e:	85 c0                	test   %eax,%eax
80102870:	74 0e                	je     80102880 <kalloc+0x20>
    kmem.freelist = r->next;
80102872:	8b 10                	mov    (%eax),%edx
80102874:	89 15 d8 4b 11 80    	mov    %edx,0x80114bd8
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
8010288e:	68 a0 4b 11 80       	push   $0x80114ba0
80102893:	e8 c8 31 00 00       	call   80105a60 <acquire>
  r = kmem.freelist;
80102898:	a1 d8 4b 11 80       	mov    0x80114bd8,%eax
  if(r)
8010289d:	83 c4 10             	add    $0x10,%esp
801028a0:	8b 15 d4 4b 11 80    	mov    0x80114bd4,%edx
801028a6:	85 c0                	test   %eax,%eax
801028a8:	74 08                	je     801028b2 <kalloc+0x52>
    kmem.freelist = r->next;
801028aa:	8b 08                	mov    (%eax),%ecx
801028ac:	89 0d d8 4b 11 80    	mov    %ecx,0x80114bd8
  if(kmem.use_lock)
801028b2:	85 d2                	test   %edx,%edx
801028b4:	74 16                	je     801028cc <kalloc+0x6c>
    release(&kmem.lock);
801028b6:	83 ec 0c             	sub    $0xc,%esp
801028b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028bc:	68 a0 4b 11 80       	push   $0x80114ba0
801028c1:	e8 5a 32 00 00       	call   80105b20 <release>
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
801028e7:	8b 0d b4 c9 10 80    	mov    0x8010c9b4,%ecx

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
80102913:	0f b6 82 a0 89 10 80 	movzbl -0x7fef7660(%edx),%eax
8010291a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010291c:	0f b6 82 a0 88 10 80 	movzbl -0x7fef7760(%edx),%eax
80102923:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102925:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102927:	89 0d b4 c9 10 80    	mov    %ecx,0x8010c9b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010292d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102930:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102933:	8b 04 85 80 88 10 80 	mov    -0x7fef7780(,%eax,4),%eax
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
80102958:	0f b6 82 a0 89 10 80 	movzbl -0x7fef7660(%edx),%eax
8010295f:	83 c8 40             	or     $0x40,%eax
80102962:	0f b6 c0             	movzbl %al,%eax
80102965:	f7 d0                	not    %eax
80102967:	21 c1                	and    %eax,%ecx
    return 0;
80102969:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010296b:	89 0d b4 c9 10 80    	mov    %ecx,0x8010c9b4
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
8010297d:	89 0d b4 c9 10 80    	mov    %ecx,0x8010c9b4
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
801029d0:	a1 dc 4b 11 80       	mov    0x80114bdc,%eax
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
80102ad0:	8b 15 dc 4b 11 80    	mov    0x80114bdc,%edx
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
80102af0:	a1 dc 4b 11 80       	mov    0x80114bdc,%eax
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
80102b5e:	a1 dc 4b 11 80       	mov    0x80114bdc,%eax
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
80102cd7:	e8 e4 2e 00 00       	call   80105bc0 <memcmp>
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
80102da0:	8b 0d 28 4c 11 80    	mov    0x80114c28,%ecx
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
80102dc0:	a1 14 4c 11 80       	mov    0x80114c14,%eax
80102dc5:	83 ec 08             	sub    $0x8,%esp
80102dc8:	01 d8                	add    %ebx,%eax
80102dca:	83 c0 01             	add    $0x1,%eax
80102dcd:	50                   	push   %eax
80102dce:	ff 35 24 4c 11 80    	pushl  0x80114c24
80102dd4:	e8 f7 d2 ff ff       	call   801000d0 <bread>
80102dd9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ddb:	58                   	pop    %eax
80102ddc:	5a                   	pop    %edx
80102ddd:	ff 34 9d 2c 4c 11 80 	pushl  -0x7feeb3d4(,%ebx,4)
80102de4:	ff 35 24 4c 11 80    	pushl  0x80114c24
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
80102e04:	e8 17 2e 00 00       	call   80105c20 <memmove>
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
80102e24:	39 1d 28 4c 11 80    	cmp    %ebx,0x80114c28
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
80102e48:	ff 35 14 4c 11 80    	pushl  0x80114c14
80102e4e:	ff 35 24 4c 11 80    	pushl  0x80114c24
80102e54:	e8 77 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e59:	8b 1d 28 4c 11 80    	mov    0x80114c28,%ebx
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
80102e70:	8b 8a 2c 4c 11 80    	mov    -0x7feeb3d4(%edx),%ecx
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
80102eaa:	68 a0 8a 10 80       	push   $0x80108aa0
80102eaf:	68 e0 4b 11 80       	push   $0x80114be0
80102eb4:	e8 67 2a 00 00       	call   80105920 <initlock>
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
80102ecc:	89 1d 24 4c 11 80    	mov    %ebx,0x80114c24
  log.size = sb.nlog;
80102ed2:	89 15 18 4c 11 80    	mov    %edx,0x80114c18
  log.start = sb.logstart;
80102ed8:	a3 14 4c 11 80       	mov    %eax,0x80114c14
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
80102eed:	89 1d 28 4c 11 80    	mov    %ebx,0x80114c28
  for (i = 0; i < log.lh.n; i++) {
80102ef3:	7e 1c                	jle    80102f11 <initlog+0x71>
80102ef5:	c1 e3 02             	shl    $0x2,%ebx
80102ef8:	31 d2                	xor    %edx,%edx
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102f00:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102f04:	83 c2 04             	add    $0x4,%edx
80102f07:	89 8a 28 4c 11 80    	mov    %ecx,-0x7feeb3d8(%edx)
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
80102f1f:	c7 05 28 4c 11 80 00 	movl   $0x0,0x80114c28
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
80102f46:	68 e0 4b 11 80       	push   $0x80114be0
80102f4b:	e8 10 2b 00 00       	call   80105a60 <acquire>
80102f50:	83 c4 10             	add    $0x10,%esp
80102f53:	eb 18                	jmp    80102f6d <begin_op+0x2d>
80102f55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f58:	83 ec 08             	sub    $0x8,%esp
80102f5b:	68 e0 4b 11 80       	push   $0x80114be0
80102f60:	68 e0 4b 11 80       	push   $0x80114be0
80102f65:	e8 c6 11 00 00       	call   80104130 <sleep>
80102f6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f6d:	a1 20 4c 11 80       	mov    0x80114c20,%eax
80102f72:	85 c0                	test   %eax,%eax
80102f74:	75 e2                	jne    80102f58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f76:	a1 1c 4c 11 80       	mov    0x80114c1c,%eax
80102f7b:	8b 15 28 4c 11 80    	mov    0x80114c28,%edx
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
80102f92:	a3 1c 4c 11 80       	mov    %eax,0x80114c1c
      release(&log.lock);
80102f97:	68 e0 4b 11 80       	push   $0x80114be0
80102f9c:	e8 7f 2b 00 00       	call   80105b20 <release>
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
80102fb9:	68 e0 4b 11 80       	push   $0x80114be0
80102fbe:	e8 9d 2a 00 00       	call   80105a60 <acquire>
  log.outstanding -= 1;
80102fc3:	a1 1c 4c 11 80       	mov    0x80114c1c,%eax
  if(log.committing)
80102fc8:	8b 35 20 4c 11 80    	mov    0x80114c20,%esi
80102fce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102fd4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102fd6:	89 1d 1c 4c 11 80    	mov    %ebx,0x80114c1c
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
80102fed:	c7 05 20 4c 11 80 01 	movl   $0x1,0x80114c20
80102ff4:	00 00 00 
  release(&log.lock);
80102ff7:	68 e0 4b 11 80       	push   $0x80114be0
80102ffc:	e8 1f 2b 00 00       	call   80105b20 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103001:	8b 0d 28 4c 11 80    	mov    0x80114c28,%ecx
80103007:	83 c4 10             	add    $0x10,%esp
8010300a:	85 c9                	test   %ecx,%ecx
8010300c:	0f 8e 85 00 00 00    	jle    80103097 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103012:	a1 14 4c 11 80       	mov    0x80114c14,%eax
80103017:	83 ec 08             	sub    $0x8,%esp
8010301a:	01 d8                	add    %ebx,%eax
8010301c:	83 c0 01             	add    $0x1,%eax
8010301f:	50                   	push   %eax
80103020:	ff 35 24 4c 11 80    	pushl  0x80114c24
80103026:	e8 a5 d0 ff ff       	call   801000d0 <bread>
8010302b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010302d:	58                   	pop    %eax
8010302e:	5a                   	pop    %edx
8010302f:	ff 34 9d 2c 4c 11 80 	pushl  -0x7feeb3d4(,%ebx,4)
80103036:	ff 35 24 4c 11 80    	pushl  0x80114c24
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
80103056:	e8 c5 2b 00 00       	call   80105c20 <memmove>
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
80103076:	3b 1d 28 4c 11 80    	cmp    0x80114c28,%ebx
8010307c:	7c 94                	jl     80103012 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010307e:	e8 bd fd ff ff       	call   80102e40 <write_head>
    install_trans(); // Now install writes to home locations
80103083:	e8 18 fd ff ff       	call   80102da0 <install_trans>
    log.lh.n = 0;
80103088:	c7 05 28 4c 11 80 00 	movl   $0x0,0x80114c28
8010308f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103092:	e8 a9 fd ff ff       	call   80102e40 <write_head>
    acquire(&log.lock);
80103097:	83 ec 0c             	sub    $0xc,%esp
8010309a:	68 e0 4b 11 80       	push   $0x80114be0
8010309f:	e8 bc 29 00 00       	call   80105a60 <acquire>
    wakeup(&log);
801030a4:	c7 04 24 e0 4b 11 80 	movl   $0x80114be0,(%esp)
    log.committing = 0;
801030ab:	c7 05 20 4c 11 80 00 	movl   $0x0,0x80114c20
801030b2:	00 00 00 
    wakeup(&log);
801030b5:	e8 26 12 00 00       	call   801042e0 <wakeup>
    release(&log.lock);
801030ba:	c7 04 24 e0 4b 11 80 	movl   $0x80114be0,(%esp)
801030c1:	e8 5a 2a 00 00       	call   80105b20 <release>
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
801030db:	68 e0 4b 11 80       	push   $0x80114be0
801030e0:	e8 fb 11 00 00       	call   801042e0 <wakeup>
  release(&log.lock);
801030e5:	c7 04 24 e0 4b 11 80 	movl   $0x80114be0,(%esp)
801030ec:	e8 2f 2a 00 00       	call   80105b20 <release>
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
801030ff:	68 a4 8a 10 80       	push   $0x80108aa4
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
80103117:	8b 15 28 4c 11 80    	mov    0x80114c28,%edx
{
8010311d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103120:	83 fa 1d             	cmp    $0x1d,%edx
80103123:	0f 8f 9d 00 00 00    	jg     801031c6 <log_write+0xb6>
80103129:	a1 18 4c 11 80       	mov    0x80114c18,%eax
8010312e:	83 e8 01             	sub    $0x1,%eax
80103131:	39 c2                	cmp    %eax,%edx
80103133:	0f 8d 8d 00 00 00    	jge    801031c6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103139:	a1 1c 4c 11 80       	mov    0x80114c1c,%eax
8010313e:	85 c0                	test   %eax,%eax
80103140:	0f 8e 8d 00 00 00    	jle    801031d3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103146:	83 ec 0c             	sub    $0xc,%esp
80103149:	68 e0 4b 11 80       	push   $0x80114be0
8010314e:	e8 0d 29 00 00       	call   80105a60 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103153:	8b 0d 28 4c 11 80    	mov    0x80114c28,%ecx
80103159:	83 c4 10             	add    $0x10,%esp
8010315c:	83 f9 00             	cmp    $0x0,%ecx
8010315f:	7e 57                	jle    801031b8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103161:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103164:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103166:	3b 15 2c 4c 11 80    	cmp    0x80114c2c,%edx
8010316c:	75 0b                	jne    80103179 <log_write+0x69>
8010316e:	eb 38                	jmp    801031a8 <log_write+0x98>
80103170:	39 14 85 2c 4c 11 80 	cmp    %edx,-0x7feeb3d4(,%eax,4)
80103177:	74 2f                	je     801031a8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103179:	83 c0 01             	add    $0x1,%eax
8010317c:	39 c1                	cmp    %eax,%ecx
8010317e:	75 f0                	jne    80103170 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103180:	89 14 85 2c 4c 11 80 	mov    %edx,-0x7feeb3d4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103187:	83 c0 01             	add    $0x1,%eax
8010318a:	a3 28 4c 11 80       	mov    %eax,0x80114c28
  b->flags |= B_DIRTY; // prevent eviction
8010318f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103192:	c7 45 08 e0 4b 11 80 	movl   $0x80114be0,0x8(%ebp)
}
80103199:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010319c:	c9                   	leave  
  release(&log.lock);
8010319d:	e9 7e 29 00 00       	jmp    80105b20 <release>
801031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801031a8:	89 14 85 2c 4c 11 80 	mov    %edx,-0x7feeb3d4(,%eax,4)
801031af:	eb de                	jmp    8010318f <log_write+0x7f>
801031b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031b8:	8b 43 08             	mov    0x8(%ebx),%eax
801031bb:	a3 2c 4c 11 80       	mov    %eax,0x80114c2c
  if (i == log.lh.n)
801031c0:	75 cd                	jne    8010318f <log_write+0x7f>
801031c2:	31 c0                	xor    %eax,%eax
801031c4:	eb c1                	jmp    80103187 <log_write+0x77>
    panic("too big a transaction");
801031c6:	83 ec 0c             	sub    $0xc,%esp
801031c9:	68 b3 8a 10 80       	push   $0x80108ab3
801031ce:	e8 bd d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801031d3:	83 ec 0c             	sub    $0xc,%esp
801031d6:	68 c9 8a 10 80       	push   $0x80108ac9
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
801031f8:	68 e4 8a 10 80       	push   $0x80108ae4
801031fd:	e8 5e d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103202:	e8 09 3c 00 00       	call   80106e10 <idtinit>
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
80103226:	e8 d5 4c 00 00       	call   80107f00 <switchkvm>
  seginit();
8010322b:	e8 40 4c 00 00       	call   80107e70 <seginit>
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
80103257:	68 48 85 11 80       	push   $0x80118548
8010325c:	e8 2f f5 ff ff       	call   80102790 <kinit1>
  kvmalloc();      // kernel page table
80103261:	e8 6a 51 00 00       	call   801083d0 <kvmalloc>
  mpinit();        // detect other processors
80103266:	e8 75 01 00 00       	call   801033e0 <mpinit>
  lapicinit();     // interrupt controller
8010326b:	e8 60 f7 ff ff       	call   801029d0 <lapicinit>
  seginit();       // segment descriptors
80103270:	e8 fb 4b 00 00       	call   80107e70 <seginit>
  picinit();       // disable pic
80103275:	e8 46 03 00 00       	call   801035c0 <picinit>
  ioapicinit();    // another interrupt controller
8010327a:	e8 41 f3 ff ff       	call   801025c0 <ioapicinit>
  procfsinit();    // procfs file system
8010327f:	e8 cc 12 00 00       	call   80104550 <procfsinit>
  consoleinit();   // console hardware
80103284:	e8 37 d7 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103289:	e8 b2 3e 00 00       	call   80107140 <uartinit>
  pinit();         // process table
8010328e:	e8 3d 08 00 00       	call   80103ad0 <pinit>
  tvinit();        // trap vectors
80103293:	e8 f8 3a 00 00       	call   80106d90 <tvinit>
  binit();         // buffer cache
80103298:	e8 a3 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010329d:	e8 be da ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
801032a2:	e8 19 f0 ff ff       	call   801022c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801032a7:	83 c4 0c             	add    $0xc,%esp
801032aa:	68 8a 00 00 00       	push   $0x8a
801032af:	68 8c c4 10 80       	push   $0x8010c48c
801032b4:	68 00 70 00 80       	push   $0x80007000
801032b9:	e8 62 29 00 00       	call   80105c20 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032be:	69 05 60 52 11 80 b0 	imul   $0xb0,0x80115260,%eax
801032c5:	00 00 00 
801032c8:	83 c4 10             	add    $0x10,%esp
801032cb:	05 e0 4c 11 80       	add    $0x80114ce0,%eax
801032d0:	3d e0 4c 11 80       	cmp    $0x80114ce0,%eax
801032d5:	76 6c                	jbe    80103343 <main+0x103>
801032d7:	bb e0 4c 11 80       	mov    $0x80114ce0,%ebx
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
801032fd:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80103304:	b0 10 00 
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
8010332a:	69 05 60 52 11 80 b0 	imul   $0xb0,0x80115260,%eax
80103331:	00 00 00 
80103334:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010333a:	05 e0 4c 11 80       	add    $0x80114ce0,%eax
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
8010338e:	68 f8 8a 10 80       	push   $0x80108af8
80103393:	56                   	push   %esi
80103394:	e8 27 28 00 00       	call   80105bc0 <memcmp>
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
8010344c:	68 15 8b 10 80       	push   $0x80108b15
80103451:	56                   	push   %esi
80103452:	e8 69 27 00 00       	call   80105bc0 <memcmp>
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
801034b7:	a3 dc 4b 11 80       	mov    %eax,0x80114bdc
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
801034e0:	ff 24 95 3c 8b 10 80 	jmp    *-0x7fef74c4(,%edx,4)
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
80103528:	8b 0d 60 52 11 80    	mov    0x80115260,%ecx
8010352e:	83 f9 07             	cmp    $0x7,%ecx
80103531:	7f 19                	jg     8010354c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103533:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103537:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010353d:	83 c1 01             	add    $0x1,%ecx
80103540:	89 0d 60 52 11 80    	mov    %ecx,0x80115260
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103546:	88 97 e0 4c 11 80    	mov    %dl,-0x7feeb320(%edi)
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
8010355f:	88 15 c0 4c 11 80    	mov    %dl,0x80114cc0
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
80103593:	68 fd 8a 10 80       	push   $0x80108afd
80103598:	e8 f3 cd ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010359d:	83 ec 0c             	sub    $0xc,%esp
801035a0:	68 1c 8b 10 80       	push   $0x80108b1c
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
8010369b:	68 50 8b 10 80       	push   $0x80108b50
801036a0:	50                   	push   %eax
801036a1:	e8 7a 22 00 00       	call   80105920 <initlock>
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
801036ff:	e8 5c 23 00 00       	call   80105a60 <acquire>
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
80103744:	e9 d7 23 00 00       	jmp    80105b20 <release>
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
80103774:	e8 a7 23 00 00       	call   80105b20 <release>
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
8010379d:	e8 be 22 00 00       	call   80105a60 <acquire>
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
80103834:	e8 e7 22 00 00       	call   80105b20 <release>
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
8010388b:	e8 90 22 00 00       	call   80105b20 <release>
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
801038b0:	e8 ab 21 00 00       	call   80105a60 <acquire>
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
8010391e:	e8 fd 21 00 00       	call   80105b20 <release>
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
8010397f:	e8 9c 21 00 00       	call   80105b20 <release>
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
801039a4:	bb b4 52 11 80       	mov    $0x801152b4,%ebx
{
801039a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801039ac:	68 80 52 11 80       	push   $0x80115280
801039b1:	e8 aa 20 00 00       	call   80105a60 <acquire>
801039b6:	83 c4 10             	add    $0x10,%esp
801039b9:	eb 14                	jmp    801039cf <allocproc+0x2f>
801039bb:	90                   	nop
801039bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039c0:	83 c3 7c             	add    $0x7c,%ebx
801039c3:	81 fb b4 71 11 80    	cmp    $0x801171b4,%ebx
801039c9:	0f 83 81 00 00 00    	jae    80103a50 <allocproc+0xb0>
    if(p->state == UNUSED)
801039cf:	8b 53 0c             	mov    0xc(%ebx),%edx
801039d2:	85 d2                	test   %edx,%edx
801039d4:	75 ea                	jne    801039c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039d6:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
801039db:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039de:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801039e5:	8d 50 01             	lea    0x1(%eax),%edx
801039e8:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801039eb:	68 80 52 11 80       	push   $0x80115280
  p->pid = nextpid++;
801039f0:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
801039f6:	e8 25 21 00 00       	call   80105b20 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039fb:	e8 60 ee ff ff       	call   80102860 <kalloc>
80103a00:	83 c4 10             	add    $0x10,%esp
80103a03:	85 c0                	test   %eax,%eax
80103a05:	89 43 08             	mov    %eax,0x8(%ebx)
80103a08:	74 5f                	je     80103a69 <allocproc+0xc9>
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
80103a1b:	c7 40 14 82 6d 10 80 	movl   $0x80106d82,0x14(%eax)
  p->context = (struct context*)sp;
80103a22:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a25:	6a 14                	push   $0x14
80103a27:	6a 00                	push   $0x0
80103a29:	50                   	push   %eax
80103a2a:	e8 41 21 00 00       	call   80105b70 <memset>
  p->context->eip = (uint)forkret;
80103a2f:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a32:	c7 40 10 80 3a 10 80 	movl   $0x80103a80,0x10(%eax)

  procfs_add_proc(p->pid);
80103a39:	58                   	pop    %eax
80103a3a:	ff 73 10             	pushl  0x10(%ebx)
80103a3d:	e8 0e 0e 00 00       	call   80104850 <procfs_add_proc>

  return p;
80103a42:	83 c4 10             	add    $0x10,%esp
}
80103a45:	89 d8                	mov    %ebx,%eax
80103a47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a4a:	c9                   	leave  
80103a4b:	c3                   	ret    
80103a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103a50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a53:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a55:	68 80 52 11 80       	push   $0x80115280
80103a5a:	e8 c1 20 00 00       	call   80105b20 <release>
}
80103a5f:	89 d8                	mov    %ebx,%eax
  return 0;
80103a61:	83 c4 10             	add    $0x10,%esp
}
80103a64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a67:	c9                   	leave  
80103a68:	c3                   	ret    
    p->state = UNUSED;
80103a69:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a70:	31 db                	xor    %ebx,%ebx
80103a72:	eb d1                	jmp    80103a45 <allocproc+0xa5>
80103a74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

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
80103a86:	68 80 52 11 80       	push   $0x80115280
80103a8b:	e8 90 20 00 00       	call   80105b20 <release>

  if (first) {
80103a90:	a1 00 c0 10 80       	mov    0x8010c000,%eax
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
80103aa3:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
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
80103ad6:	68 55 8b 10 80       	push   $0x80108b55
80103adb:	68 80 52 11 80       	push   $0x80115280
80103ae0:	e8 3b 1e 00 00       	call   80105920 <initlock>
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
80103b01:	8b 35 60 52 11 80    	mov    0x80115260,%esi
80103b07:	85 f6                	test   %esi,%esi
80103b09:	7e 42                	jle    80103b4d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103b0b:	0f b6 15 e0 4c 11 80 	movzbl 0x80114ce0,%edx
80103b12:	39 d0                	cmp    %edx,%eax
80103b14:	74 30                	je     80103b46 <mycpu+0x56>
80103b16:	b9 90 4d 11 80       	mov    $0x80114d90,%ecx
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
80103b3a:	05 e0 4c 11 80       	add    $0x80114ce0,%eax
}
80103b3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b42:	5b                   	pop    %ebx
80103b43:	5e                   	pop    %esi
80103b44:	5d                   	pop    %ebp
80103b45:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103b46:	b8 e0 4c 11 80       	mov    $0x80114ce0,%eax
      return &cpus[i];
80103b4b:	eb f2                	jmp    80103b3f <mycpu+0x4f>
  panic("unknown apicid\n");
80103b4d:	83 ec 0c             	sub    $0xc,%esp
80103b50:	68 5c 8b 10 80       	push   $0x80108b5c
80103b55:	e8 36 c8 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b5a:	83 ec 0c             	sub    $0xc,%esp
80103b5d:	68 48 8c 10 80       	push   $0x80108c48
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
80103b7b:	2d e0 4c 11 80       	sub    $0x80114ce0,%eax
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
80103b97:	e8 f4 1d 00 00       	call   80105990 <pushcli>
  c = mycpu();
80103b9c:	e8 4f ff ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103ba1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ba7:	e8 24 1e 00 00       	call   801059d0 <popcli>
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
80103bce:	a3 b8 c9 10 80       	mov    %eax,0x8010c9b8
  if((p->pgdir = setupkvm()) == 0)
80103bd3:	e8 78 47 00 00       	call   80108350 <setupkvm>
80103bd8:	85 c0                	test   %eax,%eax
80103bda:	89 43 04             	mov    %eax,0x4(%ebx)
80103bdd:	0f 84 bd 00 00 00    	je     80103ca0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103be3:	83 ec 04             	sub    $0x4,%esp
80103be6:	68 2c 00 00 00       	push   $0x2c
80103beb:	68 60 c4 10 80       	push   $0x8010c460
80103bf0:	50                   	push   %eax
80103bf1:	e8 3a 44 00 00       	call   80108030 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103bf6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103bf9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bff:	6a 4c                	push   $0x4c
80103c01:	6a 00                	push   $0x0
80103c03:	ff 73 18             	pushl  0x18(%ebx)
80103c06:	e8 65 1f 00 00       	call   80105b70 <memset>
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
80103c5f:	68 85 8b 10 80       	push   $0x80108b85
80103c64:	50                   	push   %eax
80103c65:	e8 e6 20 00 00       	call   80105d50 <safestrcpy>
  p->cwd = namei("/");
80103c6a:	c7 04 24 8e 8b 10 80 	movl   $0x80108b8e,(%esp)
80103c71:	e8 aa e4 ff ff       	call   80102120 <namei>
80103c76:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c79:	c7 04 24 80 52 11 80 	movl   $0x80115280,(%esp)
80103c80:	e8 db 1d 00 00       	call   80105a60 <acquire>
  p->state = RUNNABLE;
80103c85:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c8c:	c7 04 24 80 52 11 80 	movl   $0x80115280,(%esp)
80103c93:	e8 88 1e 00 00       	call   80105b20 <release>
}
80103c98:	83 c4 10             	add    $0x10,%esp
80103c9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c9e:	c9                   	leave  
80103c9f:	c3                   	ret    
    panic("userinit: out of memory?");
80103ca0:	83 ec 0c             	sub    $0xc,%esp
80103ca3:	68 6c 8b 10 80       	push   $0x80108b6c
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
80103cb8:	e8 d3 1c 00 00       	call   80105990 <pushcli>
  c = mycpu();
80103cbd:	e8 2e fe ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103cc2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cc8:	e8 03 1d 00 00       	call   801059d0 <popcli>
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
80103cdc:	e8 3f 42 00 00       	call   80107f20 <switchuvm>
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
80103cfa:	e8 71 44 00 00       	call   80108170 <allocuvm>
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
80103d1a:	e8 81 45 00 00       	call   801082a0 <deallocuvm>
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
80103d39:	e8 52 1c 00 00       	call   80105990 <pushcli>
  c = mycpu();
80103d3e:	e8 ad fd ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103d43:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d49:	e8 82 1c 00 00       	call   801059d0 <popcli>
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
80103d68:	e8 b3 46 00 00       	call   80108420 <copyuvm>
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
80103de1:	e8 6a 1f 00 00       	call   80105d50 <safestrcpy>
  pid = np->pid;
80103de6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103de9:	c7 04 24 80 52 11 80 	movl   $0x80115280,(%esp)
80103df0:	e8 6b 1c 00 00       	call   80105a60 <acquire>
  np->state = RUNNABLE;
80103df5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103dfc:	c7 04 24 80 52 11 80 	movl   $0x80115280,(%esp)
80103e03:	e8 18 1d 00 00       	call   80105b20 <release>
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
80103e74:	bb b4 52 11 80       	mov    $0x801152b4,%ebx
    acquire(&ptable.lock);
80103e79:	68 80 52 11 80       	push   $0x80115280
80103e7e:	e8 dd 1b 00 00       	call   80105a60 <acquire>
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
80103ea0:	e8 7b 40 00 00       	call   80107f20 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ea5:	58                   	pop    %eax
80103ea6:	5a                   	pop    %edx
80103ea7:	ff 73 1c             	pushl  0x1c(%ebx)
80103eaa:	57                   	push   %edi
      p->state = RUNNING;
80103eab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103eb2:	e8 f4 1e 00 00       	call   80105dab <swtch>
      switchkvm();
80103eb7:	e8 44 40 00 00       	call   80107f00 <switchkvm>
      c->proc = 0;
80103ebc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ec3:	00 00 00 
80103ec6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec9:	83 c3 7c             	add    $0x7c,%ebx
80103ecc:	81 fb b4 71 11 80    	cmp    $0x801171b4,%ebx
80103ed2:	72 bc                	jb     80103e90 <scheduler+0x40>
    release(&ptable.lock);
80103ed4:	83 ec 0c             	sub    $0xc,%esp
80103ed7:	68 80 52 11 80       	push   $0x80115280
80103edc:	e8 3f 1c 00 00       	call   80105b20 <release>
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
80103ef5:	e8 96 1a 00 00       	call   80105990 <pushcli>
  c = mycpu();
80103efa:	e8 f1 fb ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103eff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f05:	e8 c6 1a 00 00       	call   801059d0 <popcli>
  if(!holding(&ptable.lock))
80103f0a:	83 ec 0c             	sub    $0xc,%esp
80103f0d:	68 80 52 11 80       	push   $0x80115280
80103f12:	e8 19 1b 00 00       	call   80105a30 <holding>
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
80103f53:	e8 53 1e 00 00       	call   80105dab <swtch>
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
80103f70:	68 90 8b 10 80       	push   $0x80108b90
80103f75:	e8 16 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103f7a:	83 ec 0c             	sub    $0xc,%esp
80103f7d:	68 bc 8b 10 80       	push   $0x80108bbc
80103f82:	e8 09 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103f87:	83 ec 0c             	sub    $0xc,%esp
80103f8a:	68 ae 8b 10 80       	push   $0x80108bae
80103f8f:	e8 fc c3 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103f94:	83 ec 0c             	sub    $0xc,%esp
80103f97:	68 a2 8b 10 80       	push   $0x80108ba2
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
80103fb9:	e8 d2 19 00 00       	call   80105990 <pushcli>
  c = mycpu();
80103fbe:	e8 2d fb ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103fc3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fc9:	e8 02 1a 00 00       	call   801059d0 <popcli>
  if(curproc == initproc)
80103fce:	39 35 b8 c9 10 80    	cmp    %esi,0x8010c9b8
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
8010401b:	c7 04 24 80 52 11 80 	movl   $0x80115280,(%esp)
80104022:	e8 39 1a 00 00       	call   80105a60 <acquire>
  wakeup1(curproc->parent);
80104027:	8b 56 14             	mov    0x14(%esi),%edx
8010402a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010402d:	b8 b4 52 11 80       	mov    $0x801152b4,%eax
80104032:	eb 0e                	jmp    80104042 <exit+0x92>
80104034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104038:	83 c0 7c             	add    $0x7c,%eax
8010403b:	3d b4 71 11 80       	cmp    $0x801171b4,%eax
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
80104057:	3d b4 71 11 80       	cmp    $0x801171b4,%eax
8010405c:	72 e4                	jb     80104042 <exit+0x92>
      p->parent = initproc;
8010405e:	8b 0d b8 c9 10 80    	mov    0x8010c9b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104064:	ba b4 52 11 80       	mov    $0x801152b4,%edx
80104069:	eb 10                	jmp    8010407b <exit+0xcb>
8010406b:	90                   	nop
8010406c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104070:	83 c2 7c             	add    $0x7c,%edx
80104073:	81 fa b4 71 11 80    	cmp    $0x801171b4,%edx
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
80104089:	b8 b4 52 11 80       	mov    $0x801152b4,%eax
8010408e:	eb 0a                	jmp    8010409a <exit+0xea>
80104090:	83 c0 7c             	add    $0x7c,%eax
80104093:	3d b4 71 11 80       	cmp    $0x801171b4,%eax
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
801040bb:	e8 e0 07 00 00       	call   801048a0 <procfs_remove_proc>
  sched();
801040c0:	e8 2b fe ff ff       	call   80103ef0 <sched>
  panic("zombie exit");
801040c5:	c7 04 24 dd 8b 10 80 	movl   $0x80108bdd,(%esp)
801040cc:	e8 bf c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
801040d1:	83 ec 0c             	sub    $0xc,%esp
801040d4:	68 d0 8b 10 80       	push   $0x80108bd0
801040d9:	e8 b2 c2 ff ff       	call   80100390 <panic>
801040de:	66 90                	xchg   %ax,%ax

801040e0 <yield>:
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	53                   	push   %ebx
801040e4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040e7:	68 80 52 11 80       	push   $0x80115280
801040ec:	e8 6f 19 00 00       	call   80105a60 <acquire>
  pushcli();
801040f1:	e8 9a 18 00 00       	call   80105990 <pushcli>
  c = mycpu();
801040f6:	e8 f5 f9 ff ff       	call   80103af0 <mycpu>
  p = c->proc;
801040fb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104101:	e8 ca 18 00 00       	call   801059d0 <popcli>
  myproc()->state = RUNNABLE;
80104106:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010410d:	e8 de fd ff ff       	call   80103ef0 <sched>
  release(&ptable.lock);
80104112:	c7 04 24 80 52 11 80 	movl   $0x80115280,(%esp)
80104119:	e8 02 1a 00 00       	call   80105b20 <release>
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
8010413f:	e8 4c 18 00 00       	call   80105990 <pushcli>
  c = mycpu();
80104144:	e8 a7 f9 ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80104149:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010414f:	e8 7c 18 00 00       	call   801059d0 <popcli>
  if(p == 0)
80104154:	85 db                	test   %ebx,%ebx
80104156:	0f 84 87 00 00 00    	je     801041e3 <sleep+0xb3>
  if(lk == 0)
8010415c:	85 f6                	test   %esi,%esi
8010415e:	74 76                	je     801041d6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104160:	81 fe 80 52 11 80    	cmp    $0x80115280,%esi
80104166:	74 50                	je     801041b8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104168:	83 ec 0c             	sub    $0xc,%esp
8010416b:	68 80 52 11 80       	push   $0x80115280
80104170:	e8 eb 18 00 00       	call   80105a60 <acquire>
    release(lk);
80104175:	89 34 24             	mov    %esi,(%esp)
80104178:	e8 a3 19 00 00       	call   80105b20 <release>
  p->chan = chan;
8010417d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104180:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104187:	e8 64 fd ff ff       	call   80103ef0 <sched>
  p->chan = 0;
8010418c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104193:	c7 04 24 80 52 11 80 	movl   $0x80115280,(%esp)
8010419a:	e8 81 19 00 00       	call   80105b20 <release>
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
801041ac:	e9 af 18 00 00       	jmp    80105a60 <acquire>
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
801041d9:	68 ef 8b 10 80       	push   $0x80108bef
801041de:	e8 ad c1 ff ff       	call   80100390 <panic>
    panic("sleep");
801041e3:	83 ec 0c             	sub    $0xc,%esp
801041e6:	68 e9 8b 10 80       	push   $0x80108be9
801041eb:	e8 a0 c1 ff ff       	call   80100390 <panic>

801041f0 <wait>:
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	56                   	push   %esi
801041f4:	53                   	push   %ebx
  pushcli();
801041f5:	e8 96 17 00 00       	call   80105990 <pushcli>
  c = mycpu();
801041fa:	e8 f1 f8 ff ff       	call   80103af0 <mycpu>
  p = c->proc;
801041ff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104205:	e8 c6 17 00 00       	call   801059d0 <popcli>
  acquire(&ptable.lock);
8010420a:	83 ec 0c             	sub    $0xc,%esp
8010420d:	68 80 52 11 80       	push   $0x80115280
80104212:	e8 49 18 00 00       	call   80105a60 <acquire>
80104217:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010421a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010421c:	bb b4 52 11 80       	mov    $0x801152b4,%ebx
80104221:	eb 10                	jmp    80104233 <wait+0x43>
80104223:	90                   	nop
80104224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104228:	83 c3 7c             	add    $0x7c,%ebx
8010422b:	81 fb b4 71 11 80    	cmp    $0x801171b4,%ebx
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
80104246:	81 fb b4 71 11 80    	cmp    $0x801171b4,%ebx
8010424c:	72 e5                	jb     80104233 <wait+0x43>
    if(!havekids || curproc->killed){
8010424e:	85 c0                	test   %eax,%eax
80104250:	74 74                	je     801042c6 <wait+0xd6>
80104252:	8b 46 24             	mov    0x24(%esi),%eax
80104255:	85 c0                	test   %eax,%eax
80104257:	75 6d                	jne    801042c6 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104259:	83 ec 08             	sub    $0x8,%esp
8010425c:	68 80 52 11 80       	push   $0x80115280
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
80104289:	e8 42 40 00 00       	call   801082d0 <freevm>
        release(&ptable.lock);
8010428e:	c7 04 24 80 52 11 80 	movl   $0x80115280,(%esp)
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
801042b5:	e8 66 18 00 00       	call   80105b20 <release>
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
801042ce:	68 80 52 11 80       	push   $0x80115280
801042d3:	e8 48 18 00 00       	call   80105b20 <release>
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
801042ea:	68 80 52 11 80       	push   $0x80115280
801042ef:	e8 6c 17 00 00       	call   80105a60 <acquire>
801042f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042f7:	b8 b4 52 11 80       	mov    $0x801152b4,%eax
801042fc:	eb 0c                	jmp    8010430a <wakeup+0x2a>
801042fe:	66 90                	xchg   %ax,%ax
80104300:	83 c0 7c             	add    $0x7c,%eax
80104303:	3d b4 71 11 80       	cmp    $0x801171b4,%eax
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
8010431f:	3d b4 71 11 80       	cmp    $0x801171b4,%eax
80104324:	72 e4                	jb     8010430a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104326:	c7 45 08 80 52 11 80 	movl   $0x80115280,0x8(%ebp)
}
8010432d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104330:	c9                   	leave  
  release(&ptable.lock);
80104331:	e9 ea 17 00 00       	jmp    80105b20 <release>
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
8010434a:	68 80 52 11 80       	push   $0x80115280
8010434f:	e8 0c 17 00 00       	call   80105a60 <acquire>
80104354:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104357:	b8 b4 52 11 80       	mov    $0x801152b4,%eax
8010435c:	eb 0c                	jmp    8010436a <kill+0x2a>
8010435e:	66 90                	xchg   %ax,%ax
80104360:	83 c0 7c             	add    $0x7c,%eax
80104363:	3d b4 71 11 80       	cmp    $0x801171b4,%eax
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
80104386:	68 80 52 11 80       	push   $0x80115280
8010438b:	e8 90 17 00 00       	call   80105b20 <release>
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
801043a3:	68 80 52 11 80       	push   $0x80115280
801043a8:	e8 73 17 00 00       	call   80105b20 <release>
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
801043c9:	bb b4 52 11 80       	mov    $0x801152b4,%ebx
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
801043db:	68 d3 91 10 80       	push   $0x801091d3
801043e0:	e8 7b c2 ff ff       	call   80100660 <cprintf>
801043e5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043e8:	83 c3 7c             	add    $0x7c,%ebx
801043eb:	81 fb b4 71 11 80    	cmp    $0x801171b4,%ebx
801043f1:	0f 83 81 00 00 00    	jae    80104478 <procdump+0xb8>
    if(p->state == UNUSED)
801043f7:	8b 43 0c             	mov    0xc(%ebx),%eax
801043fa:	85 c0                	test   %eax,%eax
801043fc:	74 ea                	je     801043e8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043fe:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104401:	ba 00 8c 10 80       	mov    $0x80108c00,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104406:	77 11                	ja     80104419 <procdump+0x59>
80104408:	8b 14 85 70 8c 10 80 	mov    -0x7fef7390(,%eax,4),%edx
      state = "???";
8010440f:	b8 00 8c 10 80       	mov    $0x80108c00,%eax
80104414:	85 d2                	test   %edx,%edx
80104416:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104419:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010441c:	50                   	push   %eax
8010441d:	52                   	push   %edx
8010441e:	ff 73 10             	pushl  0x10(%ebx)
80104421:	68 04 8c 10 80       	push   $0x80108c04
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
80104448:	e8 f3 14 00 00       	call   80105940 <getcallerpcs>
8010444d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104450:	8b 17                	mov    (%edi),%edx
80104452:	85 d2                	test   %edx,%edx
80104454:	74 82                	je     801043d8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104456:	83 ec 08             	sub    $0x8,%esp
80104459:	83 c7 04             	add    $0x4,%edi
8010445c:	52                   	push   %edx
8010445d:	68 41 86 10 80       	push   $0x80108641
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
80104481:	b8 b4 52 11 80       	mov    $0x801152b4,%eax
struct proc* find_proc_by_pid(int pid) {
80104486:	89 e5                	mov    %esp,%ebp
80104488:	83 ec 08             	sub    $0x8,%esp
8010448b:	8b 55 08             	mov    0x8(%ebp),%edx
8010448e:	eb 0a                	jmp    8010449a <find_proc_by_pid+0x1a>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104490:	83 c0 7c             	add    $0x7c,%eax
80104493:	3d b4 71 11 80       	cmp    $0x801171b4,%eax
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
801044ab:	68 0d 8c 10 80       	push   $0x80108c0d
801044b0:	e8 db be ff ff       	call   80100390 <panic>
801044b5:	66 90                	xchg   %ax,%ax
801044b7:	66 90                	xchg   %ax,%ax
801044b9:	66 90                	xchg   %ax,%ax
801044bb:	66 90                	xchg   %ax,%ax
801044bd:	66 90                	xchg   %ax,%ax
801044bf:	90                   	nop

801044c0 <procfsisdir>:

struct dirent inodeinfo_dir_entries[NINODE+2];

int 
procfsisdir(struct inode *ip) 
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
  //cprintf("in func procfsisdir: ip->minor=%d ip->inum=%d\n", ip->minor, ip->inum);
  if (ip->minor == 0 || (ip->minor == 1 && (ip->inum != 500 || ip->inum != 501)))
801044c3:	8b 45 08             	mov    0x8(%ebp),%eax
		return 1;
	else 
    return 0;
}
801044c6:	5d                   	pop    %ebp
  if (ip->minor == 0 || (ip->minor == 1 && (ip->inum != 500 || ip->inum != 501)))
801044c7:	66 83 78 54 01       	cmpw   $0x1,0x54(%eax)
801044cc:	0f 96 c0             	setbe  %al
801044cf:	0f b6 c0             	movzbl %al,%eax
}
801044d2:	c3                   	ret    
801044d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044e0 <procfsiread>:

void 
procfsiread(struct inode* dp, struct inode *ip) 
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	53                   	push   %ebx
801044e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801044e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  //cprintf("in func PROCFSIREAD, ip->inum= %d, dp->inum = %d \n",ip->inum,dp->inum);
  if (ip->inum < 500) 
801044ea:	8b 50 04             	mov    0x4(%eax),%edx
801044ed:	81 fa f3 01 00 00    	cmp    $0x1f3,%edx
801044f3:	76 39                	jbe    8010452e <procfsiread+0x4e>
		return;

	ip->major = PROCFS;
	ip->size = 0;
	ip->nlink = 1;
801044f5:	bb 01 00 00 00       	mov    $0x1,%ebx
	ip->size = 0;
801044fa:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
	ip->type = T_DEV;
	ip->valid = 1;
80104501:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
	ip->nlink = 1;
80104508:	66 89 58 56          	mov    %bx,0x56(%eax)
	ip->valid = 1;
8010450c:	c7 40 50 03 00 02 00 	movl   $0x20003,0x50(%eax)
	ip->minor = dp->minor + 1;
80104513:	0f b7 59 54          	movzwl 0x54(%ecx),%ebx
80104517:	83 c3 01             	add    $0x1,%ebx
8010451a:	66 89 58 54          	mov    %bx,0x54(%eax)

	if (dp->inum < ip->inum)
8010451e:	3b 51 04             	cmp    0x4(%ecx),%edx
80104521:	76 0b                	jbe    8010452e <procfsiread+0x4e>
		ip->minor = dp->minor + 1;
80104523:	0f b7 51 54          	movzwl 0x54(%ecx),%edx
80104527:	83 c2 01             	add    $0x1,%edx
8010452a:	66 89 50 54          	mov    %dx,0x54(%eax)
	else if (dp->inum < ip->inum)
		ip->minor = dp->minor - 1;
}
8010452e:	5b                   	pop    %ebx
8010452f:	5d                   	pop    %ebp
80104530:	c3                   	ret    
80104531:	eb 0d                	jmp    80104540 <procfswrite>
80104533:	90                   	nop
80104534:	90                   	nop
80104535:	90                   	nop
80104536:	90                   	nop
80104537:	90                   	nop
80104538:	90                   	nop
80104539:	90                   	nop
8010453a:	90                   	nop
8010453b:	90                   	nop
8010453c:	90                   	nop
8010453d:	90                   	nop
8010453e:	90                   	nop
8010453f:	90                   	nop

80104540 <procfswrite>:
  }
}

int
procfswrite(struct inode *ip, char *buf, int n)
{
80104540:	55                   	push   %ebp
  return 0;
}
80104541:	31 c0                	xor    %eax,%eax
{
80104543:	89 e5                	mov    %esp,%ebp
}
80104545:	5d                   	pop    %ebp
80104546:	c3                   	ret    
80104547:	89 f6                	mov    %esi,%esi
80104549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104550 <procfsinit>:

void
procfsinit(void)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	83 ec 0c             	sub    $0xc,%esp
  devsw[PROCFS].isdir = procfsisdir;
80104556:	c7 05 a0 2e 11 80 c0 	movl   $0x801044c0,0x80112ea0
8010455d:	44 10 80 
  devsw[PROCFS].iread = procfsiread;
  devsw[PROCFS].write = procfswrite;
  devsw[PROCFS].read = procfsread;

  memset(&process_entries, sizeof(process_entries), 0);
80104560:	6a 00                	push   $0x0
80104562:	68 00 02 00 00       	push   $0x200
80104567:	68 40 75 11 80       	push   $0x80117540
  devsw[PROCFS].iread = procfsiread;
8010456c:	c7 05 a4 2e 11 80 e0 	movl   $0x801044e0,0x80112ea4
80104573:	44 10 80 
  devsw[PROCFS].write = procfswrite;
80104576:	c7 05 ac 2e 11 80 40 	movl   $0x80104540,0x80112eac
8010457d:	45 10 80 
  devsw[PROCFS].read = procfsread;
80104580:	c7 05 a8 2e 11 80 70 	movl   $0x80105770,0x80112ea8
80104587:	57 10 80 
  memset(&process_entries, sizeof(process_entries), 0);
8010458a:	e8 e1 15 00 00       	call   80105b70 <memset>
  memmove(subdir_entries[0].name, ".", 2);
8010458f:	83 c4 0c             	add    $0xc,%esp
80104592:	6a 02                	push   $0x2
80104594:	68 89 8c 10 80       	push   $0x80108c89
80104599:	68 c2 71 11 80       	push   $0x801171c2
8010459e:	e8 7d 16 00 00       	call   80105c20 <memmove>
  memmove(subdir_entries[1].name, "..", 3);
801045a3:	83 c4 0c             	add    $0xc,%esp
801045a6:	6a 03                	push   $0x3
801045a8:	68 88 8c 10 80       	push   $0x80108c88
801045ad:	68 d2 71 11 80       	push   $0x801171d2
801045b2:	e8 69 16 00 00       	call   80105c20 <memmove>
  memmove(subdir_entries[2].name, "name", 5);
801045b7:	83 c4 0c             	add    $0xc,%esp
801045ba:	6a 05                	push   $0x5
801045bc:	68 8b 8c 10 80       	push   $0x80108c8b
801045c1:	68 e2 71 11 80       	push   $0x801171e2
801045c6:	e8 55 16 00 00       	call   80105c20 <memmove>
  memmove(subdir_entries[3].name, "status", 7);
801045cb:	83 c4 0c             	add    $0xc,%esp
801045ce:	6a 07                	push   $0x7
801045d0:	68 90 8c 10 80       	push   $0x80108c90
801045d5:	68 f2 71 11 80       	push   $0x801171f2
801045da:	e8 41 16 00 00       	call   80105c20 <memmove>
  subdir_entries[0].inum = 2;
801045df:	b8 02 00 00 00       	mov    $0x2,%eax
  subdir_entries[1].inum = 1;
801045e4:	ba 01 00 00 00       	mov    $0x1,%edx
  subdir_entries[2].inum = 0; // temporary init- 
801045e9:	31 c9                	xor    %ecx,%ecx
  subdir_entries[0].inum = 2;
801045eb:	66 a3 c0 71 11 80    	mov    %ax,0x801171c0
  subdir_entries[3].inum = 0; // will be initialized in read_procfs_pid_dir
801045f1:	31 c0                	xor    %eax,%eax
  subdir_entries[1].inum = 1;
801045f3:	66 89 15 d0 71 11 80 	mov    %dx,0x801171d0
  subdir_entries[2].inum = 0; // temporary init- 
801045fa:	66 89 0d e0 71 11 80 	mov    %cx,0x801171e0
  subdir_entries[3].inum = 0; // will be initialized in read_procfs_pid_dir
80104601:	66 a3 f0 71 11 80    	mov    %ax,0x801171f0
}
80104607:	83 c4 10             	add    $0x10,%esp
8010460a:	c9                   	leave  
8010460b:	c3                   	ret    
8010460c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104610 <read_procfs_pid_dir>:
  return n;
}

int 
read_procfs_pid_dir(struct inode* ip, char *dst, int off, int n) 
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	57                   	push   %edi
80104614:	56                   	push   %esi
80104615:	53                   	push   %ebx
  //cprintf("in func read_procfs_pid_dir, ip->inum=%d \n",ip->inum);
  struct dirent temp_entries[4];
	memmove(&temp_entries, &subdir_entries, sizeof(subdir_entries));
80104616:	8d 7d a8             	lea    -0x58(%ebp),%edi

	temp_entries[2].inum = ip->inum + 100;
	temp_entries[3].inum = ip->inum + 200;

	if (off + n > sizeof(temp_entries))
		n = sizeof(temp_entries) - off;
80104619:	bb 40 00 00 00       	mov    $0x40,%ebx
{
8010461e:	83 ec 50             	sub    $0x50,%esp
80104621:	8b 75 10             	mov    0x10(%ebp),%esi
	memmove(&temp_entries, &subdir_entries, sizeof(subdir_entries));
80104624:	6a 40                	push   $0x40
80104626:	68 c0 71 11 80       	push   $0x801171c0
8010462b:	57                   	push   %edi
		n = sizeof(temp_entries) - off;
8010462c:	29 f3                	sub    %esi,%ebx
	memmove(&temp_entries, &subdir_entries, sizeof(subdir_entries));
8010462e:	e8 ed 15 00 00       	call   80105c20 <memmove>
	temp_entries[2].inum = ip->inum + 100;
80104633:	8b 45 08             	mov    0x8(%ebp),%eax
	if (off + n > sizeof(temp_entries))
80104636:	83 c4 0c             	add    $0xc,%esp
	temp_entries[2].inum = ip->inum + 100;
80104639:	8b 40 04             	mov    0x4(%eax),%eax
8010463c:	8d 48 64             	lea    0x64(%eax),%ecx
	temp_entries[3].inum = ip->inum + 200;
8010463f:	66 05 c8 00          	add    $0xc8,%ax
80104643:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
	if (off + n > sizeof(temp_entries))
80104647:	8b 45 14             	mov    0x14(%ebp),%eax
	temp_entries[2].inum = ip->inum + 100;
8010464a:	66 89 4d c8          	mov    %cx,-0x38(%ebp)
	if (off + n > sizeof(temp_entries))
8010464e:	01 f0                	add    %esi,%eax
		n = sizeof(temp_entries) - off;
80104650:	83 f8 40             	cmp    $0x40,%eax
80104653:	0f 46 5d 14          	cmovbe 0x14(%ebp),%ebx
	memmove(dst, (char*)(&temp_entries) + off, n);
80104657:	01 fe                	add    %edi,%esi
80104659:	53                   	push   %ebx
8010465a:	56                   	push   %esi
8010465b:	ff 75 0c             	pushl  0xc(%ebp)
8010465e:	e8 bd 15 00 00       	call   80105c20 <memmove>
	return n;
}
80104663:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104666:	89 d8                	mov    %ebx,%eax
80104668:	5b                   	pop    %ebx
80104669:	5e                   	pop    %esi
8010466a:	5f                   	pop    %edi
8010466b:	5d                   	pop    %ebp
8010466c:	c3                   	ret    
8010466d:	8d 76 00             	lea    0x0(%esi),%esi

80104670 <read_procfs_status>:
  }
}

int 
read_procfs_status(struct inode* ip, char *dst, int off, int n) 
{
80104670:	55                   	push   %ebp
  //cprintf("in func read_procfs_status, ip->inum=%d \n",ip->inum);
	char status[250] = {0};
80104671:	31 c0                	xor    %eax,%eax
{
80104673:	89 e5                	mov    %esp,%ebp
80104675:	57                   	push   %edi
80104676:	56                   	push   %esi
	char status[250] = {0};
80104677:	8d b5 ee fe ff ff    	lea    -0x112(%ebp),%esi
8010467d:	8d bd f0 fe ff ff    	lea    -0x110(%ebp),%edi
{
80104683:	53                   	push   %ebx
	char status[250] = {0};
80104684:	89 f1                	mov    %esi,%ecx
{
80104686:	81 ec 38 01 00 00    	sub    $0x138,%esp
	char status[250] = {0};
8010468c:	c7 85 ee fe ff ff 00 	movl   $0x0,-0x112(%ebp)
80104693:	00 00 00 
80104696:	29 f9                	sub    %edi,%ecx
80104698:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
{
8010469f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char status[250] = {0};
801046a2:	81 c1 fa 00 00 00    	add    $0xfa,%ecx
801046a8:	c1 e9 02             	shr    $0x2,%ecx
801046ab:	f3 ab                	rep stos %eax,%es:(%edi)
	//char szBuf[100] = {0};
	char* procstate[6] = { "UNUSED", "EMBRYO", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE" };
801046ad:	c7 85 d4 fe ff ff 97 	movl   $0x80108c97,-0x12c(%ebp)
801046b4:	8c 10 80 
801046b7:	c7 85 d8 fe ff ff 9e 	movl   $0x80108c9e,-0x128(%ebp)
801046be:	8c 10 80 
801046c1:	c7 85 dc fe ff ff a5 	movl   $0x80108ca5,-0x124(%ebp)
801046c8:	8c 10 80 
801046cb:	c7 85 e0 fe ff ff ae 	movl   $0x80108cae,-0x120(%ebp)
801046d2:	8c 10 80 

	int pid = ip->inum - 800;
801046d5:	8b 45 08             	mov    0x8(%ebp),%eax
	char* procstate[6] = { "UNUSED", "EMBRYO", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE" };
801046d8:	c7 85 e4 fe ff ff b7 	movl   $0x80108cb7,-0x11c(%ebp)
801046df:	8c 10 80 
801046e2:	c7 85 e8 fe ff ff bf 	movl   $0x80108cbf,-0x118(%ebp)
801046e9:	8c 10 80 
	int pid = ip->inum - 800;
801046ec:	8b 40 04             	mov    0x4(%eax),%eax
801046ef:	2d 20 03 00 00       	sub    $0x320,%eax
  struct proc *p = find_proc_by_pid(pid);
801046f4:	50                   	push   %eax
801046f5:	e8 86 fd ff ff       	call   80104480 <find_proc_by_pid>
801046fa:	89 c7                	mov    %eax,%edi

  int size = strlen(procstate[p->state]);
801046fc:	58                   	pop    %eax
801046fd:	8b 47 0c             	mov    0xc(%edi),%eax
80104700:	ff b4 85 d4 fe ff ff 	pushl  -0x12c(%ebp,%eax,4)
80104707:	e8 84 16 00 00       	call   80105d90 <strlen>
  strcpy(status, procstate[p->state]);
8010470c:	8b 57 0c             	mov    0xc(%edi),%edx
8010470f:	83 c4 10             	add    $0x10,%esp
80104712:	8b bc 95 d4 fe ff ff 	mov    -0x12c(%ebp,%edx,4),%edi
80104719:	31 d2                	xor    %edx,%edx
8010471b:	90                   	nop
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
strcpy(char *s, const char *t)
{
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
80104720:	0f b6 0c 17          	movzbl (%edi,%edx,1),%ecx
80104724:	88 0c 16             	mov    %cl,(%esi,%edx,1)
80104727:	83 c2 01             	add    $0x1,%edx
8010472a:	84 c9                	test   %cl,%cl
8010472c:	75 f2                	jne    80104720 <read_procfs_status+0xb0>
  status[strlen(status)] = '\n';
8010472e:	83 ec 0c             	sub    $0xc,%esp
  status[size] = ' ';
80104731:	c6 84 05 ee fe ff ff 	movb   $0x20,-0x112(%ebp,%eax,1)
80104738:	20 
  status[strlen(status)] = '\n';
80104739:	56                   	push   %esi
8010473a:	e8 51 16 00 00       	call   80105d90 <strlen>
  int status_size = strlen(status);
8010473f:	89 34 24             	mov    %esi,(%esp)
  status[strlen(status)] = '\n';
80104742:	c6 84 05 ee fe ff ff 	movb   $0xa,-0x112(%ebp,%eax,1)
80104749:	0a 
  int status_size = strlen(status);
8010474a:	e8 41 16 00 00       	call   80105d90 <strlen>
  if (off + n > status_size)
8010474f:	8b 55 14             	mov    0x14(%ebp),%edx
    n = status_size - off;
80104752:	89 c7                	mov    %eax,%edi
  if (off + n > status_size)
80104754:	83 c4 0c             	add    $0xc,%esp
    n = status_size - off;
80104757:	29 df                	sub    %ebx,%edi
  if (off + n > status_size)
80104759:	01 da                	add    %ebx,%edx
    n = status_size - off;
8010475b:	39 c2                	cmp    %eax,%edx
8010475d:	0f 4e 7d 14          	cmovle 0x14(%ebp),%edi
  memmove(dst, (char*)(&status) + off, n);
80104761:	01 f3                	add    %esi,%ebx
80104763:	57                   	push   %edi
80104764:	53                   	push   %ebx
80104765:	ff 75 0c             	pushl  0xc(%ebp)
80104768:	e8 b3 14 00 00       	call   80105c20 <memmove>
}
8010476d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104770:	89 f8                	mov    %edi,%eax
80104772:	5b                   	pop    %ebx
80104773:	5e                   	pop    %esi
80104774:	5f                   	pop    %edi
80104775:	5d                   	pop    %ebp
80104776:	c3                   	ret    
80104777:	89 f6                	mov    %esi,%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104780 <read_procfs_name>:
{
80104780:	55                   	push   %ebp
	char name[250] = {0};
80104781:	31 c0                	xor    %eax,%eax
{
80104783:	89 e5                	mov    %esp,%ebp
80104785:	57                   	push   %edi
80104786:	56                   	push   %esi
	char name[250] = {0};
80104787:	8d b5 ee fe ff ff    	lea    -0x112(%ebp),%esi
8010478d:	8d bd f0 fe ff ff    	lea    -0x110(%ebp),%edi
{
80104793:	53                   	push   %ebx
	char name[250] = {0};
80104794:	89 f1                	mov    %esi,%ecx
{
80104796:	81 ec 18 01 00 00    	sub    $0x118,%esp
	char name[250] = {0};
8010479c:	c7 85 ee fe ff ff 00 	movl   $0x0,-0x112(%ebp)
801047a3:	00 00 00 
801047a6:	29 f9                	sub    %edi,%ecx
801047a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
{
801047af:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char name[250] = {0};
801047b2:	81 c1 fa 00 00 00    	add    $0xfa,%ecx
801047b8:	c1 e9 02             	shr    $0x2,%ecx
801047bb:	f3 ab                	rep stos %eax,%es:(%edi)
	int pid = ip->inum - 700;
801047bd:	8b 45 08             	mov    0x8(%ebp),%eax
801047c0:	8b 40 04             	mov    0x4(%eax),%eax
801047c3:	2d bc 02 00 00       	sub    $0x2bc,%eax
  struct proc *p = find_proc_by_pid(pid);
801047c8:	50                   	push   %eax
801047c9:	e8 b2 fc ff ff       	call   80104480 <find_proc_by_pid>
  int size = strlen(p->name);
801047ce:	8d 78 6c             	lea    0x6c(%eax),%edi
801047d1:	89 3c 24             	mov    %edi,(%esp)
801047d4:	e8 b7 15 00 00       	call   80105d90 <strlen>
801047d9:	83 c4 10             	add    $0x10,%esp
801047dc:	31 d2                	xor    %edx,%edx
801047de:	66 90                	xchg   %ax,%ax
  while((*s++ = *t++) != 0)
801047e0:	0f b6 0c 17          	movzbl (%edi,%edx,1),%ecx
801047e4:	88 0c 16             	mov    %cl,(%esi,%edx,1)
801047e7:	83 c2 01             	add    $0x1,%edx
801047ea:	84 c9                	test   %cl,%cl
801047ec:	75 f2                	jne    801047e0 <read_procfs_name+0x60>
  name[strlen(name)] = '\n';
801047ee:	83 ec 0c             	sub    $0xc,%esp
  name[size] = ' ';
801047f1:	c6 84 05 ee fe ff ff 	movb   $0x20,-0x112(%ebp,%eax,1)
801047f8:	20 
  name[strlen(name)] = '\n';
801047f9:	56                   	push   %esi
801047fa:	e8 91 15 00 00       	call   80105d90 <strlen>
  int name_size = strlen(name);
801047ff:	89 34 24             	mov    %esi,(%esp)
  name[strlen(name)] = '\n';
80104802:	c6 84 05 ee fe ff ff 	movb   $0xa,-0x112(%ebp,%eax,1)
80104809:	0a 
  int name_size = strlen(name);
8010480a:	e8 81 15 00 00       	call   80105d90 <strlen>
  if (off + n > name_size)
8010480f:	8b 55 14             	mov    0x14(%ebp),%edx
    n = name_size - off;
80104812:	89 c7                	mov    %eax,%edi
  if (off + n > name_size)
80104814:	83 c4 0c             	add    $0xc,%esp
    n = name_size - off;
80104817:	29 df                	sub    %ebx,%edi
  if (off + n > name_size)
80104819:	01 da                	add    %ebx,%edx
    n = name_size - off;
8010481b:	39 c2                	cmp    %eax,%edx
8010481d:	0f 4e 7d 14          	cmovle 0x14(%ebp),%edi
  memmove(dst, (char*)(&name) + off, n);
80104821:	01 f3                	add    %esi,%ebx
80104823:	57                   	push   %edi
80104824:	53                   	push   %ebx
80104825:	ff 75 0c             	pushl  0xc(%ebp)
80104828:	e8 f3 13 00 00       	call   80105c20 <memmove>
}
8010482d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104830:	89 f8                	mov    %edi,%eax
80104832:	5b                   	pop    %ebx
80104833:	5e                   	pop    %esi
80104834:	5f                   	pop    %edi
80104835:	5d                   	pop    %ebp
80104836:	c3                   	ret    
80104837:	89 f6                	mov    %esi,%esi
80104839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104840 <read_path_level_3>:
{
80104840:	55                   	push   %ebp
}
80104841:	31 c0                	xor    %eax,%eax
{
80104843:	89 e5                	mov    %esp,%ebp
}
80104845:	5d                   	pop    %ebp
80104846:	c3                   	ret    
80104847:	89 f6                	mov    %esi,%esi
80104849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104850 <procfs_add_proc>:
{
80104850:	55                   	push   %ebp
	for (int i = 0; i < NPROC; i++) {
80104851:	31 c0                	xor    %eax,%eax
{
80104853:	89 e5                	mov    %esp,%ebp
80104855:	83 ec 08             	sub    $0x8,%esp
80104858:	eb 0e                	jmp    80104868 <procfs_add_proc+0x18>
8010485a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	for (int i = 0; i < NPROC; i++) {
80104860:	83 c0 01             	add    $0x1,%eax
80104863:	83 f8 40             	cmp    $0x40,%eax
80104866:	74 28                	je     80104890 <procfs_add_proc+0x40>
		if (!process_entries[i].used) {
80104868:	8b 14 c5 44 75 11 80 	mov    -0x7fee8abc(,%eax,8),%edx
8010486f:	85 d2                	test   %edx,%edx
80104871:	75 ed                	jne    80104860 <procfs_add_proc+0x10>
			process_entries[i].pid = pid;
80104873:	8b 55 08             	mov    0x8(%ebp),%edx
			process_entries[i].used = 1;
80104876:	c7 04 c5 44 75 11 80 	movl   $0x1,-0x7fee8abc(,%eax,8)
8010487d:	01 00 00 00 
			process_entries[i].pid = pid;
80104881:	89 14 c5 40 75 11 80 	mov    %edx,-0x7fee8ac0(,%eax,8)
}
80104888:	c9                   	leave  
80104889:	c3                   	ret    
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	panic("Too many processes in procfs!");
80104890:	83 ec 0c             	sub    $0xc,%esp
80104893:	68 c6 8c 10 80       	push   $0x80108cc6
80104898:	e8 f3 ba ff ff       	call   80100390 <panic>
8010489d:	8d 76 00             	lea    0x0(%esi),%esi

801048a0 <procfs_remove_proc>:
{
801048a0:	55                   	push   %ebp
	for (i = 0; i < NPROC; i++) {
801048a1:	31 c0                	xor    %eax,%eax
{
801048a3:	89 e5                	mov    %esp,%ebp
801048a5:	83 ec 08             	sub    $0x8,%esp
801048a8:	8b 55 08             	mov    0x8(%ebp),%edx
801048ab:	eb 0b                	jmp    801048b8 <procfs_remove_proc+0x18>
801048ad:	8d 76 00             	lea    0x0(%esi),%esi
	for (i = 0; i < NPROC; i++) {
801048b0:	83 c0 01             	add    $0x1,%eax
801048b3:	83 f8 40             	cmp    $0x40,%eax
801048b6:	74 30                	je     801048e8 <procfs_remove_proc+0x48>
		if (process_entries[i].used && process_entries[i].pid == pid) {
801048b8:	8b 0c c5 44 75 11 80 	mov    -0x7fee8abc(,%eax,8),%ecx
801048bf:	85 c9                	test   %ecx,%ecx
801048c1:	74 ed                	je     801048b0 <procfs_remove_proc+0x10>
801048c3:	39 14 c5 40 75 11 80 	cmp    %edx,-0x7fee8ac0(,%eax,8)
801048ca:	75 e4                	jne    801048b0 <procfs_remove_proc+0x10>
			process_entries[i].used = process_entries[i].pid = 0;
801048cc:	c7 04 c5 40 75 11 80 	movl   $0x0,-0x7fee8ac0(,%eax,8)
801048d3:	00 00 00 00 
801048d7:	c7 04 c5 44 75 11 80 	movl   $0x0,-0x7fee8abc(,%eax,8)
801048de:	00 00 00 00 
}
801048e2:	c9                   	leave  
801048e3:	c3                   	ret    
801048e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	panic("Failed to find process in procfs_remove_proc!");
801048e8:	83 ec 0c             	sub    $0xc,%esp
801048eb:	68 70 8e 10 80       	push   $0x80108e70
801048f0:	e8 9b ba ff ff       	call   80100390 <panic>
801048f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104900 <procfs_add_inode>:
{
80104900:	55                   	push   %ebp
80104901:	b8 60 7b 11 80       	mov    $0x80117b60,%eax
80104906:	89 e5                	mov    %esp,%ebp
80104908:	83 ec 08             	sub    $0x8,%esp
8010490b:	8b 55 08             	mov    0x8(%ebp),%edx
8010490e:	eb 0a                	jmp    8010491a <procfs_add_inode+0x1a>
80104910:	83 c0 08             	add    $0x8,%eax
  for (int i = 0; i < NINODE; i++) {
80104913:	3d f0 7c 11 80       	cmp    $0x80117cf0,%eax
80104918:	74 06                	je     80104920 <procfs_add_inode+0x20>
		if (inode_entries[i].inode == inode) {
8010491a:	39 10                	cmp    %edx,(%eax)
8010491c:	75 f2                	jne    80104910 <procfs_add_inode+0x10>
}
8010491e:	c9                   	leave  
8010491f:	c3                   	ret    
		if (!inode_entries[i].used) {
80104920:	a1 64 7b 11 80       	mov    0x80117b64,%eax
80104925:	85 c0                	test   %eax,%eax
80104927:	74 1a                	je     80104943 <procfs_add_inode+0x43>
	for (int i = 0; i < NINODE; i++) {
80104929:	b8 01 00 00 00       	mov    $0x1,%eax
8010492e:	eb 08                	jmp    80104938 <procfs_add_inode+0x38>
80104930:	83 c0 01             	add    $0x1,%eax
80104933:	83 f8 32             	cmp    $0x32,%eax
80104936:	74 28                	je     80104960 <procfs_add_inode+0x60>
		if (!inode_entries[i].used) {
80104938:	8b 0c c5 64 7b 11 80 	mov    -0x7fee849c(,%eax,8),%ecx
8010493f:	85 c9                	test   %ecx,%ecx
80104941:	75 ed                	jne    80104930 <procfs_add_inode+0x30>
      inode_entries[i].used = 1;
80104943:	c7 04 c5 64 7b 11 80 	movl   $0x1,-0x7fee849c(,%eax,8)
8010494a:	01 00 00 00 
			inode_entries[i].inode = inode;
8010494e:	89 14 c5 60 7b 11 80 	mov    %edx,-0x7fee84a0(,%eax,8)
}
80104955:	c9                   	leave  
80104956:	c3                   	ret    
80104957:	89 f6                	mov    %esi,%esi
80104959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	panic("Too many inodes in procfs!");
80104960:	83 ec 0c             	sub    $0xc,%esp
80104963:	68 e4 8c 10 80       	push   $0x80108ce4
80104968:	e8 23 ba ff ff       	call   80100390 <panic>
8010496d:	8d 76 00             	lea    0x0(%esi),%esi

80104970 <procfs_remove_inode>:
{
80104970:	55                   	push   %ebp
	for (i = 0; i < NINODE; i++) {
80104971:	31 c0                	xor    %eax,%eax
{
80104973:	89 e5                	mov    %esp,%ebp
80104975:	83 ec 08             	sub    $0x8,%esp
80104978:	8b 55 08             	mov    0x8(%ebp),%edx
8010497b:	eb 0b                	jmp    80104988 <procfs_remove_inode+0x18>
8010497d:	8d 76 00             	lea    0x0(%esi),%esi
	for (i = 0; i < NINODE; i++) {
80104980:	83 c0 01             	add    $0x1,%eax
80104983:	83 f8 32             	cmp    $0x32,%eax
80104986:	74 30                	je     801049b8 <procfs_remove_inode+0x48>
		if (inode_entries[i].used && inode_entries[i].inode == inode) {
80104988:	8b 0c c5 64 7b 11 80 	mov    -0x7fee849c(,%eax,8),%ecx
8010498f:	85 c9                	test   %ecx,%ecx
80104991:	74 ed                	je     80104980 <procfs_remove_inode+0x10>
80104993:	39 14 c5 60 7b 11 80 	cmp    %edx,-0x7fee84a0(,%eax,8)
8010499a:	75 e4                	jne    80104980 <procfs_remove_inode+0x10>
			inode_entries[i].used = 0;
8010499c:	c7 04 c5 64 7b 11 80 	movl   $0x0,-0x7fee849c(,%eax,8)
801049a3:	00 00 00 00 
      inode_entries[i].inode = 0;
801049a7:	c7 04 c5 60 7b 11 80 	movl   $0x0,-0x7fee84a0(,%eax,8)
801049ae:	00 00 00 00 
}
801049b2:	c9                   	leave  
801049b3:	c3                   	ret    
801049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	panic("Failed to find inode in procfs_remove_inode!");
801049b8:	83 ec 0c             	sub    $0xc,%esp
801049bb:	68 a0 8e 10 80       	push   $0x80108ea0
801049c0:	e8 cb b9 ff ff       	call   80100390 <panic>
801049c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049d0 <strcpy>:
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	53                   	push   %ebx
801049d4:	8b 45 08             	mov    0x8(%ebp),%eax
801049d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while((*s++ = *t++) != 0)
801049da:	89 c2                	mov    %eax,%edx
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049e0:	83 c1 01             	add    $0x1,%ecx
801049e3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
801049e7:	83 c2 01             	add    $0x1,%edx
801049ea:	84 db                	test   %bl,%bl
801049ec:	88 5a ff             	mov    %bl,-0x1(%edx)
801049ef:	75 ef                	jne    801049e0 <strcpy+0x10>
    ;
  return os;
}
801049f1:	5b                   	pop    %ebx
801049f2:	5d                   	pop    %ebp
801049f3:	c3                   	ret    
801049f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a00 <atoi>:

int
atoi(const char *s)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	53                   	push   %ebx
80104a04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
80104a07:	0f be 11             	movsbl (%ecx),%edx
80104a0a:	8d 42 d0             	lea    -0x30(%edx),%eax
80104a0d:	3c 09                	cmp    $0x9,%al
  n = 0;
80104a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
80104a14:	77 1f                	ja     80104a35 <atoi+0x35>
80104a16:	8d 76 00             	lea    0x0(%esi),%esi
80104a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
80104a20:	8d 04 80             	lea    (%eax,%eax,4),%eax
80104a23:	83 c1 01             	add    $0x1,%ecx
80104a26:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
80104a2a:	0f be 11             	movsbl (%ecx),%edx
80104a2d:	8d 5a d0             	lea    -0x30(%edx),%ebx
80104a30:	80 fb 09             	cmp    $0x9,%bl
80104a33:	76 eb                	jbe    80104a20 <atoi+0x20>
  return n;
}
80104a35:	5b                   	pop    %ebx
80104a36:	5d                   	pop    %ebp
80104a37:	c3                   	ret    
80104a38:	90                   	nop
80104a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a40 <itoa>:

// convert int to string
void 
itoa(char s[], int n)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	57                   	push   %edi
80104a44:	56                   	push   %esi
80104a45:	53                   	push   %ebx
80104a46:	31 ff                	xor    %edi,%edi
80104a48:	83 ec 0c             	sub    $0xc,%esp
80104a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104a51:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a54:	c1 f8 1f             	sar    $0x1f,%eax
80104a57:	31 c1                	xor    %eax,%ecx
80104a59:	29 c1                	sub    %eax,%ecx
80104a5b:	eb 05                	jmp    80104a62 <itoa+0x22>
80104a5d:	8d 76 00             	lea    0x0(%esi),%esi
  
  if (pm < 0) {
    n = -n;          
  }
  do {       
    s[i++] = n % 10 + '0';   
80104a60:	89 f7                	mov    %esi,%edi
80104a62:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80104a67:	8d 77 01             	lea    0x1(%edi),%esi
80104a6a:	f7 e1                	mul    %ecx
80104a6c:	c1 ea 03             	shr    $0x3,%edx
80104a6f:	8d 04 92             	lea    (%edx,%edx,4),%eax
80104a72:	01 c0                	add    %eax,%eax
80104a74:	29 c1                	sub    %eax,%ecx
80104a76:	83 c1 30             	add    $0x30,%ecx
  } while ((n /= 10) > 0);
80104a79:	85 d2                	test   %edx,%edx
    s[i++] = n % 10 + '0';   
80104a7b:	88 4c 33 ff          	mov    %cl,-0x1(%ebx,%esi,1)
  } while ((n /= 10) > 0);
80104a7f:	89 d1                	mov    %edx,%ecx
80104a81:	7f dd                	jg     80104a60 <itoa+0x20>
  
  if (pm < 0) {
80104a83:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a86:	01 de                	add    %ebx,%esi
80104a88:	85 c0                	test   %eax,%eax
80104a8a:	79 07                	jns    80104a93 <itoa+0x53>
    s[i++] = '-';
80104a8c:	c6 06 2d             	movb   $0x2d,(%esi)
80104a8f:	8d 74 3b 02          	lea    0x2(%ebx,%edi,1),%esi
  }
  s[i] = '\0';
  
  //reverse
  for (t = 0, j = strlen(s)-1; t<j; t++, j--) {
80104a93:	83 ec 0c             	sub    $0xc,%esp
  s[i] = '\0';
80104a96:	c6 06 00             	movb   $0x0,(%esi)
  for (t = 0, j = strlen(s)-1; t<j; t++, j--) {
80104a99:	53                   	push   %ebx
80104a9a:	e8 f1 12 00 00       	call   80105d90 <strlen>
80104a9f:	83 e8 01             	sub    $0x1,%eax
80104aa2:	83 c4 10             	add    $0x10,%esp
80104aa5:	85 c0                	test   %eax,%eax
80104aa7:	7e 21                	jle    80104aca <itoa+0x8a>
80104aa9:	31 d2                	xor    %edx,%edx
80104aab:	90                   	nop
80104aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = s[t];
80104ab0:	0f b6 3c 13          	movzbl (%ebx,%edx,1),%edi
    s[t] = s[j];
80104ab4:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
80104ab8:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    s[j] = c;
80104abb:	89 f9                	mov    %edi,%ecx
  for (t = 0, j = strlen(s)-1; t<j; t++, j--) {
80104abd:	83 c2 01             	add    $0x1,%edx
    s[j] = c;
80104ac0:	88 0c 03             	mov    %cl,(%ebx,%eax,1)
  for (t = 0, j = strlen(s)-1; t<j; t++, j--) {
80104ac3:	83 e8 01             	sub    $0x1,%eax
80104ac6:	39 c2                	cmp    %eax,%edx
80104ac8:	7c e6                	jl     80104ab0 <itoa+0x70>
  }
} 
80104aca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104acd:	5b                   	pop    %ebx
80104ace:	5e                   	pop    %esi
80104acf:	5f                   	pop    %edi
80104ad0:	5d                   	pop    %ebp
80104ad1:	c3                   	ret    
80104ad2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ae0 <update_dir_entries>:
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	57                   	push   %edi
80104ae4:	56                   	push   %esi
80104ae5:	53                   	push   %ebx
  dir_entries[4].inum = 502;
80104ae6:	be f6 01 00 00       	mov    $0x1f6,%esi
  dir_entries[3].inum = 501;
80104aeb:	bb f5 01 00 00       	mov    $0x1f5,%ebx
{
80104af0:	83 ec 10             	sub    $0x10,%esp
	memset(dir_entries, sizeof(dir_entries), 0);
80104af3:	6a 00                	push   $0x0
80104af5:	68 20 04 00 00       	push   $0x420
80104afa:	68 40 77 11 80       	push   $0x80117740
80104aff:	e8 6c 10 00 00       	call   80105b70 <memset>
  memmove(&dir_entries[0].name, ".", 2);
80104b04:	83 c4 0c             	add    $0xc,%esp
80104b07:	6a 02                	push   $0x2
80104b09:	68 89 8c 10 80       	push   $0x80108c89
80104b0e:	68 42 77 11 80       	push   $0x80117742
80104b13:	e8 08 11 00 00       	call   80105c20 <memmove>
  memmove(&dir_entries[1].name, "..", 3);
80104b18:	83 c4 0c             	add    $0xc,%esp
80104b1b:	6a 03                	push   $0x3
80104b1d:	68 88 8c 10 80       	push   $0x80108c88
80104b22:	68 52 77 11 80       	push   $0x80117752
80104b27:	e8 f4 10 00 00       	call   80105c20 <memmove>
  memmove(&dir_entries[2].name, "ideinfo", 8);
80104b2c:	83 c4 0c             	add    $0xc,%esp
80104b2f:	6a 08                	push   $0x8
80104b31:	68 ff 8c 10 80       	push   $0x80108cff
80104b36:	68 62 77 11 80       	push   $0x80117762
80104b3b:	e8 e0 10 00 00       	call   80105c20 <memmove>
  memmove(&dir_entries[3].name, "filestat", 9);
80104b40:	83 c4 0c             	add    $0xc,%esp
80104b43:	6a 09                	push   $0x9
80104b45:	68 07 8d 10 80       	push   $0x80108d07
80104b4a:	68 72 77 11 80       	push   $0x80117772
80104b4f:	e8 cc 10 00 00       	call   80105c20 <memmove>
  memmove(&dir_entries[4].name, "inodeinfo", 10);
80104b54:	83 c4 0c             	add    $0xc,%esp
80104b57:	6a 0a                	push   $0xa
80104b59:	68 10 8d 10 80       	push   $0x80108d10
80104b5e:	68 82 77 11 80       	push   $0x80117782
80104b63:	e8 b8 10 00 00       	call   80105c20 <memmove>
  dir_entries[0].inum = inum;
80104b68:	8b 45 08             	mov    0x8(%ebp),%eax
  dir_entries[1].inum = ROOT_INUM;
80104b6b:	ba 01 00 00 00       	mov    $0x1,%edx
  dir_entries[2].inum = 500;
80104b70:	b9 f4 01 00 00       	mov    $0x1f4,%ecx
  dir_entries[3].inum = 501;
80104b75:	66 89 1d 70 77 11 80 	mov    %bx,0x80117770
  dir_entries[4].inum = 502;
80104b7c:	66 89 35 80 77 11 80 	mov    %si,0x80117780
80104b83:	bb 40 75 11 80       	mov    $0x80117540,%ebx
  dir_entries[1].inum = ROOT_INUM;
80104b88:	66 89 15 50 77 11 80 	mov    %dx,0x80117750
  dir_entries[2].inum = 500;
80104b8f:	66 89 0d 60 77 11 80 	mov    %cx,0x80117760
80104b96:	83 c4 10             	add    $0x10,%esp
  dir_entries[0].inum = inum;
80104b99:	66 a3 40 77 11 80    	mov    %ax,0x80117740
  int j = 5;
80104b9f:	be 05 00 00 00       	mov    $0x5,%esi
80104ba4:	eb 15                	jmp    80104bbb <update_dir_entries+0xdb>
80104ba6:	8d 76 00             	lea    0x0(%esi),%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104bb0:	83 c3 08             	add    $0x8,%ebx
  for (int i = 0; i < NPROC; i++) {
80104bb3:	81 fb 40 77 11 80    	cmp    $0x80117740,%ebx
80104bb9:	74 3d                	je     80104bf8 <update_dir_entries+0x118>
		if (process_entries[i].used) {
80104bbb:	8b 43 04             	mov    0x4(%ebx),%eax
80104bbe:	85 c0                	test   %eax,%eax
80104bc0:	74 ee                	je     80104bb0 <update_dir_entries+0xd0>
			itoa(dir_entries[j].name, process_entries[i].pid);
80104bc2:	89 f7                	mov    %esi,%edi
80104bc4:	83 ec 08             	sub    $0x8,%esp
80104bc7:	ff 33                	pushl  (%ebx)
80104bc9:	c1 e7 04             	shl    $0x4,%edi
80104bcc:	83 c3 08             	add    $0x8,%ebx
			j++;
80104bcf:	83 c6 01             	add    $0x1,%esi
			itoa(dir_entries[j].name, process_entries[i].pid);
80104bd2:	8d 87 42 77 11 80    	lea    -0x7fee88be(%edi),%eax
80104bd8:	50                   	push   %eax
80104bd9:	e8 62 fe ff ff       	call   80104a40 <itoa>
			dir_entries[j].inum = 600 + process_entries[i].pid;
80104bde:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
			j++;
80104be2:	83 c4 10             	add    $0x10,%esp
			dir_entries[j].inum = 600 + process_entries[i].pid;
80104be5:	66 05 58 02          	add    $0x258,%ax
  for (int i = 0; i < NPROC; i++) {
80104be9:	81 fb 40 77 11 80    	cmp    $0x80117740,%ebx
			dir_entries[j].inum = 600 + process_entries[i].pid;
80104bef:	66 89 87 40 77 11 80 	mov    %ax,-0x7fee88c0(%edi)
  for (int i = 0; i < NPROC; i++) {
80104bf6:	75 c3                	jne    80104bbb <update_dir_entries+0xdb>
}
80104bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bfb:	5b                   	pop    %ebx
80104bfc:	5e                   	pop    %esi
80104bfd:	5f                   	pop    %edi
80104bfe:	5d                   	pop    %ebp
80104bff:	c3                   	ret    

80104c00 <read_path_level_0>:
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	57                   	push   %edi
80104c04:	56                   	push   %esi
80104c05:	53                   	push   %ebx
      n = sizeof(dir_entries) - off;
80104c06:	bb 20 04 00 00       	mov    $0x420,%ebx
{
80104c0b:	83 ec 18             	sub    $0x18,%esp
  update_dir_entries(ip->inum);
80104c0e:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104c11:	8b 75 10             	mov    0x10(%ebp),%esi
80104c14:	8b 7d 14             	mov    0x14(%ebp),%edi
  update_dir_entries(ip->inum);
80104c17:	ff 70 04             	pushl  0x4(%eax)
      n = sizeof(dir_entries) - off;
80104c1a:	29 f3                	sub    %esi,%ebx
  update_dir_entries(ip->inum);
80104c1c:	e8 bf fe ff ff       	call   80104ae0 <update_dir_entries>
  if (off + n > sizeof(dir_entries))
80104c21:	8d 04 3e             	lea    (%esi,%edi,1),%eax
80104c24:	83 c4 0c             	add    $0xc,%esp
      n = sizeof(dir_entries) - off;
80104c27:	3d 20 04 00 00       	cmp    $0x420,%eax
80104c2c:	0f 46 df             	cmovbe %edi,%ebx
  memmove(dst, (char*)(&dir_entries) + off, n);
80104c2f:	81 c6 40 77 11 80    	add    $0x80117740,%esi
80104c35:	53                   	push   %ebx
80104c36:	56                   	push   %esi
80104c37:	ff 75 0c             	pushl  0xc(%ebp)
80104c3a:	e8 e1 0f 00 00       	call   80105c20 <memmove>
}
80104c3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c42:	89 d8                	mov    %ebx,%eax
80104c44:	5b                   	pop    %ebx
80104c45:	5e                   	pop    %esi
80104c46:	5f                   	pop    %edi
80104c47:	5d                   	pop    %ebp
80104c48:	c3                   	ret    
80104c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c50 <update_inode_entries>:
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	57                   	push   %edi
80104c54:	56                   	push   %esi
80104c55:	53                   	push   %ebx
  int j = 2;
80104c56:	bf 02 00 00 00       	mov    $0x2,%edi
80104c5b:	bb 60 7b 11 80       	mov    $0x80117b60,%ebx
{
80104c60:	83 ec 20             	sub    $0x20,%esp
	memset(inodeinfo_dir_entries, sizeof(inodeinfo_dir_entries), 0);
80104c63:	6a 00                	push   $0x0
80104c65:	68 40 03 00 00       	push   $0x340
80104c6a:	68 00 72 11 80       	push   $0x80117200
80104c6f:	e8 fc 0e 00 00       	call   80105b70 <memset>
  memmove(&inodeinfo_dir_entries[0].name, ".", 2);
80104c74:	83 c4 0c             	add    $0xc,%esp
80104c77:	6a 02                	push   $0x2
80104c79:	68 89 8c 10 80       	push   $0x80108c89
80104c7e:	68 02 72 11 80       	push   $0x80117202
80104c83:	e8 98 0f 00 00       	call   80105c20 <memmove>
  memmove(&inodeinfo_dir_entries[1].name, "..", 3);
80104c88:	83 c4 0c             	add    $0xc,%esp
80104c8b:	6a 03                	push   $0x3
80104c8d:	68 88 8c 10 80       	push   $0x80108c88
80104c92:	68 12 72 11 80       	push   $0x80117212
80104c97:	e8 84 0f 00 00       	call   80105c20 <memmove>
  inodeinfo_dir_entries[0].inum = inum;
80104c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  inodeinfo_dir_entries[1].inum = ROOT_INUM;
80104c9f:	ba 01 00 00 00       	mov    $0x1,%edx
80104ca4:	83 c4 10             	add    $0x10,%esp
80104ca7:	66 89 15 10 72 11 80 	mov    %dx,0x80117210
  inodeinfo_dir_entries[0].inum = inum;
80104cae:	66 a3 00 72 11 80    	mov    %ax,0x80117200
80104cb4:	eb 15                	jmp    80104ccb <update_inode_entries+0x7b>
80104cb6:	8d 76 00             	lea    0x0(%esi),%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104cc0:	83 c3 08             	add    $0x8,%ebx
  for (int i = 0; i < NINODE; i++) {
80104cc3:	81 fb f0 7c 11 80    	cmp    $0x80117cf0,%ebx
80104cc9:	74 55                	je     80104d20 <update_inode_entries+0xd0>
    if (inode_entries[i].used) {
80104ccb:	8b 43 04             	mov    0x4(%ebx),%eax
80104cce:	85 c0                	test   %eax,%eax
80104cd0:	74 ee                	je     80104cc0 <update_inode_entries+0x70>
      int index = get_inode_index(inode_entries[i].inode->inum);
80104cd2:	8b 03                	mov    (%ebx),%eax
80104cd4:	83 ec 0c             	sub    $0xc,%esp
80104cd7:	ff 70 04             	pushl  0x4(%eax)
80104cda:	e8 81 d4 ff ff       	call   80102160 <get_inode_index>
      if(index >= 0){ // if index==-1 it is not found in the open inode table (ichache)
80104cdf:	83 c4 10             	add    $0x10,%esp
80104ce2:	85 c0                	test   %eax,%eax
      int index = get_inode_index(inode_entries[i].inode->inum);
80104ce4:	89 c6                	mov    %eax,%esi
      if(index >= 0){ // if index==-1 it is not found in the open inode table (ichache)
80104ce6:	78 2a                	js     80104d12 <update_inode_entries+0xc2>
        itoa(inodeinfo_dir_entries[j].name, index);
80104ce8:	83 ec 08             	sub    $0x8,%esp
        inodeinfo_dir_entries[j].inum = 900 + index;
80104ceb:	66 81 c6 84 03       	add    $0x384,%si
        itoa(inodeinfo_dir_entries[j].name, index);
80104cf0:	50                   	push   %eax
80104cf1:	89 f8                	mov    %edi,%eax
80104cf3:	c1 e0 04             	shl    $0x4,%eax
80104cf6:	8d 90 02 72 11 80    	lea    -0x7fee8dfe(%eax),%edx
80104cfc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104cff:	52                   	push   %edx
80104d00:	e8 3b fd ff ff       	call   80104a40 <itoa>
        inodeinfo_dir_entries[j].inum = 900 + index;
80104d05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104d08:	83 c4 10             	add    $0x10,%esp
80104d0b:	66 89 b0 00 72 11 80 	mov    %si,-0x7fee8e00(%eax)
80104d12:	83 c3 08             	add    $0x8,%ebx
      j++;
80104d15:	83 c7 01             	add    $0x1,%edi
  for (int i = 0; i < NINODE; i++) {
80104d18:	81 fb f0 7c 11 80    	cmp    $0x80117cf0,%ebx
80104d1e:	75 ab                	jne    80104ccb <update_inode_entries+0x7b>
}
80104d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d23:	5b                   	pop    %ebx
80104d24:	5e                   	pop    %esi
80104d25:	5f                   	pop    %edi
80104d26:	5d                   	pop    %ebp
80104d27:	c3                   	ret    
80104d28:	90                   	nop
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d30 <read_file_inodeinfo>:
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	57                   	push   %edi
80104d34:	56                   	push   %esi
80104d35:	53                   	push   %ebx
      n = sizeof(inodeinfo_dir_entries) - off;
80104d36:	bb 40 03 00 00       	mov    $0x340,%ebx
{
80104d3b:	83 ec 18             	sub    $0x18,%esp
  update_inode_entries(ip->inum);
80104d3e:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104d41:	8b 75 10             	mov    0x10(%ebp),%esi
80104d44:	8b 7d 14             	mov    0x14(%ebp),%edi
  update_inode_entries(ip->inum);
80104d47:	ff 70 04             	pushl  0x4(%eax)
      n = sizeof(inodeinfo_dir_entries) - off;
80104d4a:	29 f3                	sub    %esi,%ebx
  update_inode_entries(ip->inum);
80104d4c:	e8 ff fe ff ff       	call   80104c50 <update_inode_entries>
  if (off + n > sizeof(inodeinfo_dir_entries))
80104d51:	8d 04 3e             	lea    (%esi,%edi,1),%eax
80104d54:	83 c4 0c             	add    $0xc,%esp
      n = sizeof(inodeinfo_dir_entries) - off;
80104d57:	3d 40 03 00 00       	cmp    $0x340,%eax
80104d5c:	0f 46 df             	cmovbe %edi,%ebx
  memmove(dst, (char*)(&inodeinfo_dir_entries) + off, n);
80104d5f:	81 c6 00 72 11 80    	add    $0x80117200,%esi
80104d65:	53                   	push   %ebx
80104d66:	56                   	push   %esi
80104d67:	ff 75 0c             	pushl  0xc(%ebp)
80104d6a:	e8 b1 0e 00 00       	call   80105c20 <memmove>
}
80104d6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d72:	89 d8                	mov    %ebx,%eax
80104d74:	5b                   	pop    %ebx
80104d75:	5e                   	pop    %esi
80104d76:	5f                   	pop    %edi
80104d77:	5d                   	pop    %ebp
80104d78:	c3                   	ret    
80104d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d80 <get_string_working_blocks>:
{
80104d80:	55                   	push   %ebp
80104d81:	31 c0                	xor    %eax,%eax
80104d83:	89 e5                	mov    %esp,%ebp
80104d85:	57                   	push   %edi
80104d86:	56                   	push   %esi
80104d87:	53                   	push   %ebx
80104d88:	83 ec 0c             	sub    $0xc,%esp
80104d8b:	90                   	nop
80104d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80104d90:	0f b6 90 1a 8d 10 80 	movzbl -0x7fef72e6(%eax),%edx
80104d97:	83 c0 01             	add    $0x1,%eax
80104d9a:	88 90 bf c9 10 80    	mov    %dl,-0x7fef3641(%eax)
80104da0:	84 d2                	test   %dl,%dl
80104da2:	75 ec                	jne    80104d90 <get_string_working_blocks+0x10>
80104da4:	8b 75 08             	mov    0x8(%ebp),%esi
80104da7:	8d 9e 00 04 00 00    	lea    0x400(%esi),%ebx
80104dad:	eb 0c                	jmp    80104dbb <get_string_working_blocks+0x3b>
80104daf:	90                   	nop
80104db0:	83 c6 08             	add    $0x8,%esi
  for(int i=0; i < 256; i = i+2){
80104db3:	39 de                	cmp    %ebx,%esi
80104db5:	0f 84 d1 00 00 00    	je     80104e8c <get_string_working_blocks+0x10c>
    if(q[i] != 0){
80104dbb:	8b 3e                	mov    (%esi),%edi
80104dbd:	85 ff                	test   %edi,%edi
80104dbf:	74 ef                	je     80104db0 <get_string_working_blocks+0x30>
      strcpy(currQueueData + strlen(currQueueData), "(");
80104dc1:	83 ec 0c             	sub    $0xc,%esp
80104dc4:	68 c0 c9 10 80       	push   $0x8010c9c0
80104dc9:	e8 c2 0f 00 00       	call   80105d90 <strlen>
80104dce:	83 c4 10             	add    $0x10,%esp
80104dd1:	05 c0 c9 10 80       	add    $0x8010c9c0,%eax
80104dd6:	31 d2                	xor    %edx,%edx
80104dd8:	90                   	nop
80104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80104de0:	0f b6 8a 14 8e 10 80 	movzbl -0x7fef71ec(%edx),%ecx
80104de7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104dea:	83 c2 01             	add    $0x1,%edx
80104ded:	84 c9                	test   %cl,%cl
80104def:	75 ef                	jne    80104de0 <get_string_working_blocks+0x60>
      itoa(currQueueData + strlen(currQueueData), q[i]);
80104df1:	83 ec 0c             	sub    $0xc,%esp
80104df4:	8b 3e                	mov    (%esi),%edi
80104df6:	68 c0 c9 10 80       	push   $0x8010c9c0
80104dfb:	e8 90 0f 00 00       	call   80105d90 <strlen>
80104e00:	5a                   	pop    %edx
80104e01:	59                   	pop    %ecx
80104e02:	05 c0 c9 10 80       	add    $0x8010c9c0,%eax
80104e07:	57                   	push   %edi
80104e08:	50                   	push   %eax
80104e09:	e8 32 fc ff ff       	call   80104a40 <itoa>
      strcpy(currQueueData + strlen(currQueueData), ",");
80104e0e:	c7 04 24 c0 c9 10 80 	movl   $0x8010c9c0,(%esp)
80104e15:	e8 76 0f 00 00       	call   80105d90 <strlen>
80104e1a:	83 c4 10             	add    $0x10,%esp
80104e1d:	05 c0 c9 10 80       	add    $0x8010c9c0,%eax
80104e22:	31 d2                	xor    %edx,%edx
80104e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80104e28:	0f b6 8a 2b 8d 10 80 	movzbl -0x7fef72d5(%edx),%ecx
80104e2f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104e32:	83 c2 01             	add    $0x1,%edx
80104e35:	84 c9                	test   %cl,%cl
80104e37:	75 ef                	jne    80104e28 <get_string_working_blocks+0xa8>
      itoa(currQueueData + strlen(currQueueData), q[i+1]);
80104e39:	83 ec 0c             	sub    $0xc,%esp
80104e3c:	8b 7e 04             	mov    0x4(%esi),%edi
80104e3f:	68 c0 c9 10 80       	push   $0x8010c9c0
80104e44:	e8 47 0f 00 00       	call   80105d90 <strlen>
80104e49:	5a                   	pop    %edx
80104e4a:	59                   	pop    %ecx
80104e4b:	05 c0 c9 10 80       	add    $0x8010c9c0,%eax
80104e50:	57                   	push   %edi
80104e51:	50                   	push   %eax
80104e52:	e8 e9 fb ff ff       	call   80104a40 <itoa>
      strcpy(currQueueData + strlen(currQueueData), ");");
80104e57:	c7 04 24 c0 c9 10 80 	movl   $0x8010c9c0,(%esp)
80104e5e:	e8 2d 0f 00 00       	call   80105d90 <strlen>
80104e63:	83 c4 10             	add    $0x10,%esp
80104e66:	05 c0 c9 10 80       	add    $0x8010c9c0,%eax
80104e6b:	31 d2                	xor    %edx,%edx
80104e6d:	8d 76 00             	lea    0x0(%esi),%esi
  while((*s++ = *t++) != 0)
80104e70:	0f b6 8a 2d 8d 10 80 	movzbl -0x7fef72d3(%edx),%ecx
80104e77:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104e7a:	83 c2 01             	add    $0x1,%edx
80104e7d:	84 c9                	test   %cl,%cl
80104e7f:	75 ef                	jne    80104e70 <get_string_working_blocks+0xf0>
80104e81:	83 c6 08             	add    $0x8,%esi
  for(int i=0; i < 256; i = i+2){
80104e84:	39 de                	cmp    %ebx,%esi
80104e86:	0f 85 2f ff ff ff    	jne    80104dbb <get_string_working_blocks+0x3b>
}
80104e8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e8f:	b8 c0 c9 10 80       	mov    $0x8010c9c0,%eax
80104e94:	5b                   	pop    %ebx
80104e95:	5e                   	pop    %esi
80104e96:	5f                   	pop    %edi
80104e97:	5d                   	pop    %ebp
80104e98:	c3                   	ret    
80104e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ea0 <read_file_ideinfo.part.0>:
read_file_ideinfo(struct inode* ip, char *dst, int off, int n) 
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	57                   	push   %edi
80104ea4:	56                   	push   %esi
80104ea5:	53                   	push   %ebx
	char data[256] = {0};
80104ea6:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
read_file_ideinfo(struct inode* ip, char *dst, int off, int n) 
80104eac:	89 ce                	mov    %ecx,%esi
	char data[256] = {0};
80104eae:	b9 40 00 00 00       	mov    $0x40,%ecx
read_file_ideinfo(struct inode* ip, char *dst, int off, int n) 
80104eb3:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
	char data[256] = {0};
80104eb9:	89 df                	mov    %ebx,%edi
read_file_ideinfo(struct inode* ip, char *dst, int off, int n) 
80104ebb:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
	char data[256] = {0};
80104ec1:	31 c0                	xor    %eax,%eax
read_file_ideinfo(struct inode* ip, char *dst, int off, int n) 
80104ec3:	89 95 e4 fe ff ff    	mov    %edx,-0x11c(%ebp)
	char data[256] = {0};
80104ec9:	f3 ab                	rep stos %eax,%es:(%edi)
80104ecb:	90                   	nop
80104ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80104ed0:	0f b6 90 30 8d 10 80 	movzbl -0x7fef72d0(%eax),%edx
80104ed7:	88 14 03             	mov    %dl,(%ebx,%eax,1)
80104eda:	83 c0 01             	add    $0x1,%eax
80104edd:	84 d2                	test   %dl,%dl
80104edf:	75 ef                	jne    80104ed0 <read_file_ideinfo.part.0+0x30>
	itoa(data + strlen(data), get_waiting_ops());
80104ee1:	e8 4a d6 ff ff       	call   80102530 <get_waiting_ops>
80104ee6:	83 ec 0c             	sub    $0xc,%esp
80104ee9:	89 c7                	mov    %eax,%edi
80104eeb:	53                   	push   %ebx
80104eec:	e8 9f 0e 00 00       	call   80105d90 <strlen>
80104ef1:	5a                   	pop    %edx
80104ef2:	59                   	pop    %ecx
80104ef3:	01 d8                	add    %ebx,%eax
80104ef5:	57                   	push   %edi
80104ef6:	50                   	push   %eax
80104ef7:	e8 44 fb ff ff       	call   80104a40 <itoa>
	strcpy(data + strlen(data), "\nRead waiting operations: ");
80104efc:	89 1c 24             	mov    %ebx,(%esp)
80104eff:	e8 8c 0e 00 00       	call   80105d90 <strlen>
80104f04:	83 c4 10             	add    $0x10,%esp
80104f07:	01 d8                	add    %ebx,%eax
80104f09:	31 d2                	xor    %edx,%edx
80104f0b:	90                   	nop
80104f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80104f10:	0f b6 8a 45 8d 10 80 	movzbl -0x7fef72bb(%edx),%ecx
80104f17:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104f1a:	83 c2 01             	add    $0x1,%edx
80104f1d:	84 c9                	test   %cl,%cl
80104f1f:	75 ef                	jne    80104f10 <read_file_ideinfo.part.0+0x70>
	itoa(data + strlen(data), get_read_wait_ops());
80104f21:	e8 ba d5 ff ff       	call   801024e0 <get_read_wait_ops>
80104f26:	83 ec 0c             	sub    $0xc,%esp
80104f29:	89 c7                	mov    %eax,%edi
80104f2b:	53                   	push   %ebx
80104f2c:	e8 5f 0e 00 00       	call   80105d90 <strlen>
80104f31:	5a                   	pop    %edx
80104f32:	59                   	pop    %ecx
80104f33:	01 d8                	add    %ebx,%eax
80104f35:	57                   	push   %edi
80104f36:	50                   	push   %eax
80104f37:	e8 04 fb ff ff       	call   80104a40 <itoa>
	strcpy(data + strlen(data), "\nWrite waiting operations: ");
80104f3c:	89 1c 24             	mov    %ebx,(%esp)
80104f3f:	e8 4c 0e 00 00       	call   80105d90 <strlen>
80104f44:	83 c4 10             	add    $0x10,%esp
80104f47:	01 d8                	add    %ebx,%eax
80104f49:	31 d2                	xor    %edx,%edx
80104f4b:	90                   	nop
80104f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80104f50:	0f b6 8a 60 8d 10 80 	movzbl -0x7fef72a0(%edx),%ecx
80104f57:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104f5a:	83 c2 01             	add    $0x1,%edx
80104f5d:	84 c9                	test   %cl,%cl
80104f5f:	75 ef                	jne    80104f50 <read_file_ideinfo.part.0+0xb0>
	itoa(data + strlen(data), get_write_wait_ops());
80104f61:	e8 ea d5 ff ff       	call   80102550 <get_write_wait_ops>
80104f66:	83 ec 0c             	sub    $0xc,%esp
80104f69:	89 c7                	mov    %eax,%edi
80104f6b:	53                   	push   %ebx
80104f6c:	e8 1f 0e 00 00       	call   80105d90 <strlen>
80104f71:	5a                   	pop    %edx
80104f72:	59                   	pop    %ecx
80104f73:	01 d8                	add    %ebx,%eax
80104f75:	57                   	push   %edi
80104f76:	50                   	push   %eax
80104f77:	e8 c4 fa ff ff       	call   80104a40 <itoa>
  strcpy(data + strlen(data), "\n");
80104f7c:	89 1c 24             	mov    %ebx,(%esp)
80104f7f:	e8 0c 0e 00 00       	call   80105d90 <strlen>
80104f84:	83 c4 10             	add    $0x10,%esp
80104f87:	01 d8                	add    %ebx,%eax
80104f89:	31 d2                	xor    %edx,%edx
80104f8b:	90                   	nop
80104f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80104f90:	0f b6 8a d3 91 10 80 	movzbl -0x7fef6e2d(%edx),%ecx
80104f97:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104f9a:	83 c2 01             	add    $0x1,%edx
80104f9d:	84 c9                	test   %cl,%cl
80104f9f:	75 ef                	jne    80104f90 <read_file_ideinfo.part.0+0xf0>
  char* workBlocks = get_string_working_blocks(get_working_blocks());
80104fa1:	e8 ba d5 ff ff       	call   80102560 <get_working_blocks>
80104fa6:	83 ec 0c             	sub    $0xc,%esp
80104fa9:	50                   	push   %eax
80104faa:	e8 d1 fd ff ff       	call   80104d80 <get_string_working_blocks>
  strcpy(data + strlen(data), workBlocks);
80104faf:	89 1c 24             	mov    %ebx,(%esp)
  char* workBlocks = get_string_working_blocks(get_working_blocks());
80104fb2:	89 c7                	mov    %eax,%edi
  strcpy(data + strlen(data), workBlocks);
80104fb4:	e8 d7 0d 00 00       	call   80105d90 <strlen>
80104fb9:	83 c4 10             	add    $0x10,%esp
80104fbc:	01 d8                	add    %ebx,%eax
80104fbe:	66 90                	xchg   %ax,%ax
  while((*s++ = *t++) != 0)
80104fc0:	83 c7 01             	add    $0x1,%edi
80104fc3:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104fc7:	83 c0 01             	add    $0x1,%eax
80104fca:	84 d2                	test   %dl,%dl
80104fcc:	88 50 ff             	mov    %dl,-0x1(%eax)
80104fcf:	75 ef                	jne    80104fc0 <read_file_ideinfo.part.0+0x120>
	strcpy(data + strlen(data), "\n");
80104fd1:	83 ec 0c             	sub    $0xc,%esp
80104fd4:	53                   	push   %ebx
80104fd5:	e8 b6 0d 00 00       	call   80105d90 <strlen>
80104fda:	83 c4 10             	add    $0x10,%esp
80104fdd:	01 d8                	add    %ebx,%eax
80104fdf:	31 d2                	xor    %edx,%edx
80104fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80104fe8:	0f b6 8a d3 91 10 80 	movzbl -0x7fef6e2d(%edx),%ecx
80104fef:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104ff2:	83 c2 01             	add    $0x1,%edx
80104ff5:	84 c9                	test   %cl,%cl
80104ff7:	75 ef                	jne    80104fe8 <read_file_ideinfo.part.0+0x148>
	if (off + n > strlen(data))
80104ff9:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
80104fff:	83 ec 0c             	sub    $0xc,%esp
80105002:	53                   	push   %ebx
80105003:	8d 3c 06             	lea    (%esi,%eax,1),%edi
80105006:	e8 85 0d 00 00       	call   80105d90 <strlen>
8010500b:	83 c4 10             	add    $0x10,%esp
8010500e:	39 c7                	cmp    %eax,%edi
80105010:	7f 26                	jg     80105038 <read_file_ideinfo.part.0+0x198>
	memmove(dst, (char*)(&data) + off, n);
80105012:	03 9d e4 fe ff ff    	add    -0x11c(%ebp),%ebx
80105018:	83 ec 04             	sub    $0x4,%esp
8010501b:	56                   	push   %esi
8010501c:	53                   	push   %ebx
8010501d:	ff b5 e0 fe ff ff    	pushl  -0x120(%ebp)
80105023:	e8 f8 0b 00 00       	call   80105c20 <memmove>
}
80105028:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010502b:	89 f0                	mov    %esi,%eax
8010502d:	5b                   	pop    %ebx
8010502e:	5e                   	pop    %esi
8010502f:	5f                   	pop    %edi
80105030:	5d                   	pop    %ebp
80105031:	c3                   	ret    
80105032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		n = strlen(data) - off;
80105038:	83 ec 0c             	sub    $0xc,%esp
8010503b:	53                   	push   %ebx
8010503c:	e8 4f 0d 00 00       	call   80105d90 <strlen>
80105041:	2b 85 e4 fe ff ff    	sub    -0x11c(%ebp),%eax
80105047:	83 c4 10             	add    $0x10,%esp
8010504a:	89 c6                	mov    %eax,%esi
8010504c:	eb c4                	jmp    80105012 <read_file_ideinfo.part.0+0x172>
8010504e:	66 90                	xchg   %ax,%ax

80105050 <read_file_ideinfo>:
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	8b 4d 14             	mov    0x14(%ebp),%ecx
80105056:	8b 45 0c             	mov    0xc(%ebp),%eax
80105059:	8b 55 10             	mov    0x10(%ebp),%edx
  if (n == sizeof(struct dirent))
8010505c:	83 f9 10             	cmp    $0x10,%ecx
8010505f:	74 0f                	je     80105070 <read_file_ideinfo+0x20>
}
80105061:	5d                   	pop    %ebp
80105062:	e9 39 fe ff ff       	jmp    80104ea0 <read_file_ideinfo.part.0>
80105067:	89 f6                	mov    %esi,%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105070:	31 c0                	xor    %eax,%eax
80105072:	5d                   	pop    %ebp
80105073:	c3                   	ret    
80105074:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010507a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105080 <read_file_filestat.part.1>:
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	57                   	push   %edi
80105084:	56                   	push   %esi
80105085:	53                   	push   %ebx
	char data[256] = {0};
80105086:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
8010508c:	89 ce                	mov    %ecx,%esi
	char data[256] = {0};
8010508e:	b9 40 00 00 00       	mov    $0x40,%ecx
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
80105093:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
	char data[256] = {0};
80105099:	89 df                	mov    %ebx,%edi
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
8010509b:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
	char data[256] = {0};
801050a1:	31 c0                	xor    %eax,%eax
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
801050a3:	89 95 e4 fe ff ff    	mov    %edx,-0x11c(%ebp)
	char data[256] = {0};
801050a9:	f3 ab                	rep stos %eax,%es:(%edi)
801050ab:	90                   	nop
801050ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
801050b0:	0f b6 90 7c 8d 10 80 	movzbl -0x7fef7284(%eax),%edx
801050b7:	88 14 03             	mov    %dl,(%ebx,%eax,1)
801050ba:	83 c0 01             	add    $0x1,%eax
801050bd:	84 d2                	test   %dl,%dl
801050bf:	75 ef                	jne    801050b0 <read_file_filestat.part.1+0x30>
	itoa(data + strlen(data), get_free_fds());
801050c1:	e8 4a c0 ff ff       	call   80101110 <get_free_fds>
801050c6:	83 ec 0c             	sub    $0xc,%esp
801050c9:	89 c7                	mov    %eax,%edi
801050cb:	53                   	push   %ebx
801050cc:	e8 bf 0c 00 00       	call   80105d90 <strlen>
801050d1:	5a                   	pop    %edx
801050d2:	59                   	pop    %ecx
801050d3:	01 d8                	add    %ebx,%eax
801050d5:	57                   	push   %edi
801050d6:	50                   	push   %eax
801050d7:	e8 64 f9 ff ff       	call   80104a40 <itoa>
	strcpy(data + strlen(data), "\nUnique inode fds: ");
801050dc:	89 1c 24             	mov    %ebx,(%esp)
801050df:	e8 ac 0c 00 00       	call   80105d90 <strlen>
801050e4:	83 c4 10             	add    $0x10,%esp
801050e7:	01 d8                	add    %ebx,%eax
801050e9:	31 d2                	xor    %edx,%edx
801050eb:	90                   	nop
801050ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
801050f0:	0f b6 8a 87 8d 10 80 	movzbl -0x7fef7279(%edx),%ecx
801050f7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801050fa:	83 c2 01             	add    $0x1,%edx
801050fd:	84 c9                	test   %cl,%cl
801050ff:	75 ef                	jne    801050f0 <read_file_filestat.part.1+0x70>
	itoa(data + strlen(data), get_unique_inode_fds()); // TODO
80105101:	e8 5a c0 ff ff       	call   80101160 <get_unique_inode_fds>
80105106:	83 ec 0c             	sub    $0xc,%esp
80105109:	89 c7                	mov    %eax,%edi
8010510b:	53                   	push   %ebx
8010510c:	e8 7f 0c 00 00       	call   80105d90 <strlen>
80105111:	5a                   	pop    %edx
80105112:	59                   	pop    %ecx
80105113:	01 d8                	add    %ebx,%eax
80105115:	57                   	push   %edi
80105116:	50                   	push   %eax
80105117:	e8 24 f9 ff ff       	call   80104a40 <itoa>
	strcpy(data + strlen(data), "\nWriteable fds: ");
8010511c:	89 1c 24             	mov    %ebx,(%esp)
8010511f:	e8 6c 0c 00 00       	call   80105d90 <strlen>
80105124:	83 c4 10             	add    $0x10,%esp
80105127:	01 d8                	add    %ebx,%eax
80105129:	31 d2                	xor    %edx,%edx
8010512b:	90                   	nop
8010512c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105130:	0f b6 8a 9b 8d 10 80 	movzbl -0x7fef7265(%edx),%ecx
80105137:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010513a:	83 c2 01             	add    $0x1,%edx
8010513d:	84 c9                	test   %cl,%cl
8010513f:	75 ef                	jne    80105130 <read_file_filestat.part.1+0xb0>
	itoa(data + strlen(data), get_writeable_fds());
80105141:	e8 2a c0 ff ff       	call   80101170 <get_writeable_fds>
80105146:	83 ec 0c             	sub    $0xc,%esp
80105149:	89 c7                	mov    %eax,%edi
8010514b:	53                   	push   %ebx
8010514c:	e8 3f 0c 00 00       	call   80105d90 <strlen>
80105151:	5a                   	pop    %edx
80105152:	59                   	pop    %ecx
80105153:	01 d8                	add    %ebx,%eax
80105155:	57                   	push   %edi
80105156:	50                   	push   %eax
80105157:	e8 e4 f8 ff ff       	call   80104a40 <itoa>
  strcpy(data + strlen(data), "\nReadable fds: ");
8010515c:	89 1c 24             	mov    %ebx,(%esp)
8010515f:	e8 2c 0c 00 00       	call   80105d90 <strlen>
80105164:	83 c4 10             	add    $0x10,%esp
80105167:	01 d8                	add    %ebx,%eax
80105169:	31 d2                	xor    %edx,%edx
8010516b:	90                   	nop
8010516c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105170:	0f b6 8a ac 8d 10 80 	movzbl -0x7fef7254(%edx),%ecx
80105177:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010517a:	83 c2 01             	add    $0x1,%edx
8010517d:	84 c9                	test   %cl,%cl
8010517f:	75 ef                	jne    80105170 <read_file_filestat.part.1+0xf0>
	itoa(data + strlen(data), get_readable_fds());
80105181:	e8 3a c0 ff ff       	call   801011c0 <get_readable_fds>
80105186:	83 ec 0c             	sub    $0xc,%esp
80105189:	89 c7                	mov    %eax,%edi
8010518b:	53                   	push   %ebx
8010518c:	e8 ff 0b 00 00       	call   80105d90 <strlen>
80105191:	5a                   	pop    %edx
80105192:	59                   	pop    %ecx
80105193:	01 d8                	add    %ebx,%eax
80105195:	57                   	push   %edi
80105196:	50                   	push   %eax
80105197:	e8 a4 f8 ff ff       	call   80104a40 <itoa>
  strcpy(data + strlen(data), "\nRefs per fds: ");
8010519c:	89 1c 24             	mov    %ebx,(%esp)
8010519f:	e8 ec 0b 00 00       	call   80105d90 <strlen>
801051a4:	83 c4 10             	add    $0x10,%esp
801051a7:	01 d8                	add    %ebx,%eax
801051a9:	31 d2                	xor    %edx,%edx
801051ab:	90                   	nop
801051ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
801051b0:	0f b6 8a bc 8d 10 80 	movzbl -0x7fef7244(%edx),%ecx
801051b7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801051ba:	83 c2 01             	add    $0x1,%edx
801051bd:	84 c9                	test   %cl,%cl
801051bf:	75 ef                	jne    801051b0 <read_file_filestat.part.1+0x130>
	itoa(data + strlen(data), get_total_refs());
801051c1:	e8 4a c0 ff ff       	call   80101210 <get_total_refs>
801051c6:	83 ec 0c             	sub    $0xc,%esp
801051c9:	89 c7                	mov    %eax,%edi
801051cb:	53                   	push   %ebx
801051cc:	e8 bf 0b 00 00       	call   80105d90 <strlen>
801051d1:	5a                   	pop    %edx
801051d2:	59                   	pop    %ecx
801051d3:	01 d8                	add    %ebx,%eax
801051d5:	57                   	push   %edi
801051d6:	50                   	push   %eax
801051d7:	e8 64 f8 ff ff       	call   80104a40 <itoa>
	strcpy(data + strlen(data), " / ");
801051dc:	89 1c 24             	mov    %ebx,(%esp)
801051df:	e8 ac 0b 00 00       	call   80105d90 <strlen>
801051e4:	83 c4 10             	add    $0x10,%esp
801051e7:	01 d8                	add    %ebx,%eax
801051e9:	31 d2                	xor    %edx,%edx
801051eb:	90                   	nop
801051ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
801051f0:	0f b6 8a cc 8d 10 80 	movzbl -0x7fef7234(%edx),%ecx
801051f7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801051fa:	83 c2 01             	add    $0x1,%edx
801051fd:	84 c9                	test   %cl,%cl
801051ff:	75 ef                	jne    801051f0 <read_file_filestat.part.1+0x170>
	itoa(data + strlen(data), get_used_fds());
80105201:	e8 5a c0 ff ff       	call   80101260 <get_used_fds>
80105206:	83 ec 0c             	sub    $0xc,%esp
80105209:	89 c7                	mov    %eax,%edi
8010520b:	53                   	push   %ebx
8010520c:	e8 7f 0b 00 00       	call   80105d90 <strlen>
80105211:	5a                   	pop    %edx
80105212:	59                   	pop    %ecx
80105213:	01 d8                	add    %ebx,%eax
80105215:	57                   	push   %edi
80105216:	50                   	push   %eax
80105217:	e8 24 f8 ff ff       	call   80104a40 <itoa>
	strcpy(data + strlen(data), "\n");
8010521c:	89 1c 24             	mov    %ebx,(%esp)
8010521f:	e8 6c 0b 00 00       	call   80105d90 <strlen>
80105224:	83 c4 10             	add    $0x10,%esp
80105227:	01 d8                	add    %ebx,%eax
80105229:	31 d2                	xor    %edx,%edx
8010522b:	90                   	nop
8010522c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105230:	0f b6 8a d3 91 10 80 	movzbl -0x7fef6e2d(%edx),%ecx
80105237:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010523a:	83 c2 01             	add    $0x1,%edx
8010523d:	84 c9                	test   %cl,%cl
8010523f:	75 ef                	jne    80105230 <read_file_filestat.part.1+0x1b0>
	if (off + n > strlen(data))
80105241:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
80105247:	83 ec 0c             	sub    $0xc,%esp
8010524a:	53                   	push   %ebx
8010524b:	8d 3c 06             	lea    (%esi,%eax,1),%edi
8010524e:	e8 3d 0b 00 00       	call   80105d90 <strlen>
80105253:	83 c4 10             	add    $0x10,%esp
80105256:	39 c7                	cmp    %eax,%edi
80105258:	7f 26                	jg     80105280 <read_file_filestat.part.1+0x200>
	memmove(dst, (char*)(&data) + off, n);
8010525a:	03 9d e4 fe ff ff    	add    -0x11c(%ebp),%ebx
80105260:	83 ec 04             	sub    $0x4,%esp
80105263:	56                   	push   %esi
80105264:	53                   	push   %ebx
80105265:	ff b5 e0 fe ff ff    	pushl  -0x120(%ebp)
8010526b:	e8 b0 09 00 00       	call   80105c20 <memmove>
}
80105270:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105273:	89 f0                	mov    %esi,%eax
80105275:	5b                   	pop    %ebx
80105276:	5e                   	pop    %esi
80105277:	5f                   	pop    %edi
80105278:	5d                   	pop    %ebp
80105279:	c3                   	ret    
8010527a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		n = strlen(data) - off;
80105280:	83 ec 0c             	sub    $0xc,%esp
80105283:	53                   	push   %ebx
80105284:	e8 07 0b 00 00       	call   80105d90 <strlen>
80105289:	2b 85 e4 fe ff ff    	sub    -0x11c(%ebp),%eax
8010528f:	83 c4 10             	add    $0x10,%esp
80105292:	89 c6                	mov    %eax,%esi
80105294:	eb c4                	jmp    8010525a <read_file_filestat.part.1+0x1da>
80105296:	8d 76 00             	lea    0x0(%esi),%esi
80105299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052a0 <read_file_filestat>:
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	8b 4d 14             	mov    0x14(%ebp),%ecx
801052a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801052a9:	8b 55 10             	mov    0x10(%ebp),%edx
  if (n == sizeof(struct dirent))
801052ac:	83 f9 10             	cmp    $0x10,%ecx
801052af:	74 0f                	je     801052c0 <read_file_filestat+0x20>
}
801052b1:	5d                   	pop    %ebp
801052b2:	e9 c9 fd ff ff       	jmp    80105080 <read_file_filestat.part.1>
801052b7:	89 f6                	mov    %esi,%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801052c0:	31 c0                	xor    %eax,%eax
801052c2:	5d                   	pop    %ebp
801052c3:	c3                   	ret    
801052c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801052ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801052d0 <read_path_level_1>:
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	53                   	push   %ebx
  switch (ip->inum) {
801052d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
{
801052d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801052da:	8b 55 10             	mov    0x10(%ebp),%edx
801052dd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  switch (ip->inum) {
801052e0:	8b 5b 04             	mov    0x4(%ebx),%ebx
801052e3:	81 fb f5 01 00 00    	cmp    $0x1f5,%ebx
801052e9:	74 35                	je     80105320 <read_path_level_1+0x50>
801052eb:	81 fb f6 01 00 00    	cmp    $0x1f6,%ebx
801052f1:	74 25                	je     80105318 <read_path_level_1+0x48>
801052f3:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
801052f9:	74 0d                	je     80105308 <read_path_level_1+0x38>
}
801052fb:	5b                   	pop    %ebx
801052fc:	5d                   	pop    %ebp
      return read_procfs_pid_dir(ip, dst, off, n);
801052fd:	e9 0e f3 ff ff       	jmp    80104610 <read_procfs_pid_dir>
80105302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if (n == sizeof(struct dirent))
80105308:	83 f9 10             	cmp    $0x10,%ecx
8010530b:	75 23                	jne    80105330 <read_path_level_1+0x60>
}
8010530d:	31 c0                	xor    %eax,%eax
8010530f:	5b                   	pop    %ebx
80105310:	5d                   	pop    %ebp
80105311:	c3                   	ret    
80105312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105318:	5b                   	pop    %ebx
80105319:	5d                   	pop    %ebp
      return read_file_inodeinfo(ip, dst, off, n); //should be a directory
8010531a:	e9 11 fa ff ff       	jmp    80104d30 <read_file_inodeinfo>
8010531f:	90                   	nop
  if (n == sizeof(struct dirent))
80105320:	83 f9 10             	cmp    $0x10,%ecx
80105323:	74 e8                	je     8010530d <read_path_level_1+0x3d>
}
80105325:	5b                   	pop    %ebx
80105326:	5d                   	pop    %ebp
80105327:	e9 54 fd ff ff       	jmp    80105080 <read_file_filestat.part.1>
8010532c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105330:	5b                   	pop    %ebx
80105331:	5d                   	pop    %ebp
80105332:	e9 69 fb ff ff       	jmp    80104ea0 <read_file_ideinfo.part.0>
80105337:	89 f6                	mov    %esi,%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105340 <read_inodeinfo_file.part.3>:
read_inodeinfo_file(struct inode* ip, char *dst, int off, int n) 
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	57                   	push   %edi
80105344:	56                   	push   %esi
80105345:	53                   	push   %ebx
	char data[256] = {0};
80105346:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
read_inodeinfo_file(struct inode* ip, char *dst, int off, int n) 
8010534c:	89 c6                	mov    %eax,%esi
	char data[256] = {0};
8010534e:	31 c0                	xor    %eax,%eax
read_inodeinfo_file(struct inode* ip, char *dst, int off, int n) 
80105350:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
	char data[256] = {0};
80105356:	89 df                	mov    %ebx,%edi
read_inodeinfo_file(struct inode* ip, char *dst, int off, int n) 
80105358:	89 8d e4 fe ff ff    	mov    %ecx,-0x11c(%ebp)
	char data[256] = {0};
8010535e:	b9 40 00 00 00       	mov    $0x40,%ecx
read_inodeinfo_file(struct inode* ip, char *dst, int off, int n) 
80105363:	89 95 e0 fe ff ff    	mov    %edx,-0x120(%ebp)
	char data[256] = {0};
80105369:	f3 ab                	rep stos %eax,%es:(%edi)
8010536b:	90                   	nop
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105370:	0f b6 90 d0 8d 10 80 	movzbl -0x7fef7230(%eax),%edx
80105377:	88 14 03             	mov    %dl,(%ebx,%eax,1)
8010537a:	83 c0 01             	add    $0x1,%eax
8010537d:	84 d2                	test   %dl,%dl
8010537f:	75 ef                	jne    80105370 <read_inodeinfo_file.part.3+0x30>
	itoa(data + strlen(data), ip->dev);
80105381:	83 ec 0c             	sub    $0xc,%esp
80105384:	8b 3e                	mov    (%esi),%edi
80105386:	53                   	push   %ebx
80105387:	e8 04 0a 00 00       	call   80105d90 <strlen>
8010538c:	5a                   	pop    %edx
8010538d:	59                   	pop    %ecx
8010538e:	01 d8                	add    %ebx,%eax
80105390:	57                   	push   %edi
80105391:	50                   	push   %eax
80105392:	e8 a9 f6 ff ff       	call   80104a40 <itoa>
	strcpy(data + strlen(data), "\nInode number: ");
80105397:	89 1c 24             	mov    %ebx,(%esp)
8010539a:	e8 f1 09 00 00       	call   80105d90 <strlen>
8010539f:	83 c4 10             	add    $0x10,%esp
801053a2:	01 d8                	add    %ebx,%eax
801053a4:	31 d2                	xor    %edx,%edx
801053a6:	8d 76 00             	lea    0x0(%esi),%esi
801053a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  while((*s++ = *t++) != 0)
801053b0:	0f b6 8a d9 8d 10 80 	movzbl -0x7fef7227(%edx),%ecx
801053b7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801053ba:	83 c2 01             	add    $0x1,%edx
801053bd:	84 c9                	test   %cl,%cl
801053bf:	75 ef                	jne    801053b0 <read_inodeinfo_file.part.3+0x70>
	itoa(data + strlen(data), ip->inum); 
801053c1:	83 ec 0c             	sub    $0xc,%esp
801053c4:	8b 7e 04             	mov    0x4(%esi),%edi
801053c7:	53                   	push   %ebx
801053c8:	e8 c3 09 00 00       	call   80105d90 <strlen>
801053cd:	5a                   	pop    %edx
801053ce:	59                   	pop    %ecx
801053cf:	01 d8                	add    %ebx,%eax
801053d1:	57                   	push   %edi
801053d2:	50                   	push   %eax
801053d3:	e8 68 f6 ff ff       	call   80104a40 <itoa>
	strcpy(data + strlen(data), "\nis valid: ");
801053d8:	89 1c 24             	mov    %ebx,(%esp)
801053db:	e8 b0 09 00 00       	call   80105d90 <strlen>
801053e0:	83 c4 10             	add    $0x10,%esp
801053e3:	01 d8                	add    %ebx,%eax
801053e5:	31 d2                	xor    %edx,%edx
801053e7:	89 f6                	mov    %esi,%esi
801053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  while((*s++ = *t++) != 0)
801053f0:	0f b6 8a e9 8d 10 80 	movzbl -0x7fef7217(%edx),%ecx
801053f7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801053fa:	83 c2 01             	add    $0x1,%edx
801053fd:	84 c9                	test   %cl,%cl
801053ff:	75 ef                	jne    801053f0 <read_inodeinfo_file.part.3+0xb0>
	itoa(data + strlen(data), ip->valid);
80105401:	83 ec 0c             	sub    $0xc,%esp
80105404:	8b 7e 4c             	mov    0x4c(%esi),%edi
80105407:	53                   	push   %ebx
80105408:	e8 83 09 00 00       	call   80105d90 <strlen>
8010540d:	5a                   	pop    %edx
8010540e:	59                   	pop    %ecx
8010540f:	01 d8                	add    %ebx,%eax
80105411:	57                   	push   %edi
80105412:	50                   	push   %eax
80105413:	e8 28 f6 ff ff       	call   80104a40 <itoa>
  strcpy(data + strlen(data), "\ntype: ");
80105418:	89 1c 24             	mov    %ebx,(%esp)
8010541b:	e8 70 09 00 00       	call   80105d90 <strlen>
80105420:	83 c4 10             	add    $0x10,%esp
80105423:	01 d8                	add    %ebx,%eax
80105425:	31 d2                	xor    %edx,%edx
80105427:	89 f6                	mov    %esi,%esi
80105429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  while((*s++ = *t++) != 0)
80105430:	0f b6 8a f5 8d 10 80 	movzbl -0x7fef720b(%edx),%ecx
80105437:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010543a:	83 c2 01             	add    $0x1,%edx
8010543d:	84 c9                	test   %cl,%cl
8010543f:	75 ef                	jne    80105430 <read_inodeinfo_file.part.3+0xf0>
  if(ip->type == T_DIR)
80105441:	0f b7 46 50          	movzwl 0x50(%esi),%eax
80105445:	66 83 f8 01          	cmp    $0x1,%ax
80105449:	0f 84 21 02 00 00    	je     80105670 <read_inodeinfo_file.part.3+0x330>
  if(ip->type == T_FILE)
8010544f:	66 83 f8 02          	cmp    $0x2,%ax
80105453:	0f 84 e7 01 00 00    	je     80105640 <read_inodeinfo_file.part.3+0x300>
  if(ip->type == T_DEV)
80105459:	66 83 f8 03          	cmp    $0x3,%ax
8010545d:	0f 84 ad 01 00 00    	je     80105610 <read_inodeinfo_file.part.3+0x2d0>
  strcpy(data + strlen(data), "\nmajor minor: (");
80105463:	83 ec 0c             	sub    $0xc,%esp
80105466:	53                   	push   %ebx
80105467:	e8 24 09 00 00       	call   80105d90 <strlen>
8010546c:	83 c4 10             	add    $0x10,%esp
8010546f:	01 d8                	add    %ebx,%eax
80105471:	31 d2                	xor    %edx,%edx
80105473:	90                   	nop
80105474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105478:	0f b6 8a 06 8e 10 80 	movzbl -0x7fef71fa(%edx),%ecx
8010547f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105482:	83 c2 01             	add    $0x1,%edx
80105485:	84 c9                	test   %cl,%cl
80105487:	75 ef                	jne    80105478 <read_inodeinfo_file.part.3+0x138>
	itoa(data + strlen(data), ip->major);
80105489:	83 ec 0c             	sub    $0xc,%esp
8010548c:	0f bf 7e 52          	movswl 0x52(%esi),%edi
80105490:	53                   	push   %ebx
80105491:	e8 fa 08 00 00       	call   80105d90 <strlen>
80105496:	5a                   	pop    %edx
80105497:	59                   	pop    %ecx
80105498:	01 d8                	add    %ebx,%eax
8010549a:	57                   	push   %edi
8010549b:	50                   	push   %eax
8010549c:	e8 9f f5 ff ff       	call   80104a40 <itoa>
  strcpy(data + strlen(data), ", ");
801054a1:	89 1c 24             	mov    %ebx,(%esp)
801054a4:	e8 e7 08 00 00       	call   80105d90 <strlen>
801054a9:	83 c4 10             	add    $0x10,%esp
801054ac:	01 d8                	add    %ebx,%eax
801054ae:	31 d2                	xor    %edx,%edx
  while((*s++ = *t++) != 0)
801054b0:	0f b6 8a 16 8e 10 80 	movzbl -0x7fef71ea(%edx),%ecx
801054b7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801054ba:	83 c2 01             	add    $0x1,%edx
801054bd:	84 c9                	test   %cl,%cl
801054bf:	75 ef                	jne    801054b0 <read_inodeinfo_file.part.3+0x170>
	itoa(data + strlen(data), ip->minor);
801054c1:	83 ec 0c             	sub    $0xc,%esp
801054c4:	0f bf 7e 54          	movswl 0x54(%esi),%edi
801054c8:	53                   	push   %ebx
801054c9:	e8 c2 08 00 00       	call   80105d90 <strlen>
801054ce:	5a                   	pop    %edx
801054cf:	59                   	pop    %ecx
801054d0:	01 d8                	add    %ebx,%eax
801054d2:	57                   	push   %edi
801054d3:	50                   	push   %eax
801054d4:	e8 67 f5 ff ff       	call   80104a40 <itoa>
  strcpy(data + strlen(data), ")");
801054d9:	89 1c 24             	mov    %ebx,(%esp)
801054dc:	e8 af 08 00 00       	call   80105d90 <strlen>
801054e1:	83 c4 10             	add    $0x10,%esp
801054e4:	01 d8                	add    %ebx,%eax
801054e6:	31 d2                	xor    %edx,%edx
801054e8:	90                   	nop
801054e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
801054f0:	0f b6 8a 5d 86 10 80 	movzbl -0x7fef79a3(%edx),%ecx
801054f7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801054fa:	83 c2 01             	add    $0x1,%edx
801054fd:	84 c9                	test   %cl,%cl
801054ff:	75 ef                	jne    801054f0 <read_inodeinfo_file.part.3+0x1b0>
	strcpy(data + strlen(data), "\nhard links: ");
80105501:	83 ec 0c             	sub    $0xc,%esp
80105504:	53                   	push   %ebx
80105505:	e8 86 08 00 00       	call   80105d90 <strlen>
8010550a:	83 c4 10             	add    $0x10,%esp
8010550d:	01 d8                	add    %ebx,%eax
8010550f:	31 d2                	xor    %edx,%edx
80105511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105518:	0f b6 8a 19 8e 10 80 	movzbl -0x7fef71e7(%edx),%ecx
8010551f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105522:	83 c2 01             	add    $0x1,%edx
80105525:	84 c9                	test   %cl,%cl
80105527:	75 ef                	jne    80105518 <read_inodeinfo_file.part.3+0x1d8>
	itoa(data + strlen(data), ip->ref);
80105529:	83 ec 0c             	sub    $0xc,%esp
8010552c:	8b 7e 08             	mov    0x8(%esi),%edi
8010552f:	53                   	push   %ebx
80105530:	e8 5b 08 00 00       	call   80105d90 <strlen>
80105535:	5a                   	pop    %edx
80105536:	59                   	pop    %ecx
80105537:	01 d8                	add    %ebx,%eax
80105539:	57                   	push   %edi
8010553a:	50                   	push   %eax
8010553b:	e8 00 f5 ff ff       	call   80104a40 <itoa>
  strcpy(data + strlen(data), "\nblocks used: ");
80105540:	89 1c 24             	mov    %ebx,(%esp)
80105543:	e8 48 08 00 00       	call   80105d90 <strlen>
80105548:	83 c4 10             	add    $0x10,%esp
8010554b:	01 d8                	add    %ebx,%eax
8010554d:	31 d2                	xor    %edx,%edx
8010554f:	90                   	nop
  while((*s++ = *t++) != 0)
80105550:	0f b6 8a 27 8e 10 80 	movzbl -0x7fef71d9(%edx),%ecx
80105557:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010555a:	83 c2 01             	add    $0x1,%edx
8010555d:	84 c9                	test   %cl,%cl
8010555f:	75 ef                	jne    80105550 <read_inodeinfo_file.part.3+0x210>
  if(ip->type == T_DEV)
80105561:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
80105566:	0f 84 84 00 00 00    	je     801055f0 <read_inodeinfo_file.part.3+0x2b0>
	strcpy(data + strlen(data), "\n");
8010556c:	83 ec 0c             	sub    $0xc,%esp
8010556f:	53                   	push   %ebx
80105570:	e8 1b 08 00 00       	call   80105d90 <strlen>
80105575:	83 c4 10             	add    $0x10,%esp
80105578:	01 d8                	add    %ebx,%eax
8010557a:	31 d2                	xor    %edx,%edx
8010557c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
80105580:	0f b6 8a d3 91 10 80 	movzbl -0x7fef6e2d(%edx),%ecx
80105587:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010558a:	83 c2 01             	add    $0x1,%edx
8010558d:	84 c9                	test   %cl,%cl
8010558f:	75 ef                	jne    80105580 <read_inodeinfo_file.part.3+0x240>
	if (off + n > strlen(data))
80105591:	8b b5 e4 fe ff ff    	mov    -0x11c(%ebp),%esi
80105597:	03 75 08             	add    0x8(%ebp),%esi
8010559a:	83 ec 0c             	sub    $0xc,%esp
8010559d:	53                   	push   %ebx
8010559e:	e8 ed 07 00 00       	call   80105d90 <strlen>
801055a3:	83 c4 10             	add    $0x10,%esp
801055a6:	39 c6                	cmp    %eax,%esi
801055a8:	7f 26                	jg     801055d0 <read_inodeinfo_file.part.3+0x290>
	memmove(dst, (char*)(&data) + off, n);
801055aa:	03 9d e4 fe ff ff    	add    -0x11c(%ebp),%ebx
801055b0:	83 ec 04             	sub    $0x4,%esp
801055b3:	ff 75 08             	pushl  0x8(%ebp)
801055b6:	53                   	push   %ebx
801055b7:	ff b5 e0 fe ff ff    	pushl  -0x120(%ebp)
801055bd:	e8 5e 06 00 00       	call   80105c20 <memmove>
}
801055c2:	8b 45 08             	mov    0x8(%ebp),%eax
801055c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055c8:	5b                   	pop    %ebx
801055c9:	5e                   	pop    %esi
801055ca:	5f                   	pop    %edi
801055cb:	5d                   	pop    %ebp
801055cc:	c3                   	ret    
801055cd:	8d 76 00             	lea    0x0(%esi),%esi
		n = strlen(data) - off;
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	53                   	push   %ebx
801055d4:	e8 b7 07 00 00       	call   80105d90 <strlen>
801055d9:	2b 85 e4 fe ff ff    	sub    -0x11c(%ebp),%eax
801055df:	83 c4 10             	add    $0x10,%esp
801055e2:	89 45 08             	mov    %eax,0x8(%ebp)
801055e5:	eb c3                	jmp    801055aa <read_inodeinfo_file.part.3+0x26a>
801055e7:	89 f6                	mov    %esi,%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    itoa(data + strlen(data), 0);
801055f0:	83 ec 0c             	sub    $0xc,%esp
801055f3:	53                   	push   %ebx
801055f4:	e8 97 07 00 00       	call   80105d90 <strlen>
801055f9:	5a                   	pop    %edx
801055fa:	59                   	pop    %ecx
801055fb:	01 d8                	add    %ebx,%eax
801055fd:	6a 00                	push   $0x0
801055ff:	50                   	push   %eax
80105600:	e8 3b f4 ff ff       	call   80104a40 <itoa>
80105605:	83 c4 10             	add    $0x10,%esp
80105608:	e9 5f ff ff ff       	jmp    8010556c <read_inodeinfo_file.part.3+0x22c>
8010560d:	8d 76 00             	lea    0x0(%esi),%esi
    strcpy(data + strlen(data), "DEV");
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	53                   	push   %ebx
80105614:	e8 77 07 00 00       	call   80105d90 <strlen>
80105619:	83 c4 10             	add    $0x10,%esp
8010561c:	01 d8                	add    %ebx,%eax
8010561e:	31 d2                	xor    %edx,%edx
  while((*s++ = *t++) != 0)
80105620:	0f b6 8a 02 8e 10 80 	movzbl -0x7fef71fe(%edx),%ecx
80105627:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010562a:	83 c2 01             	add    $0x1,%edx
8010562d:	84 c9                	test   %cl,%cl
8010562f:	75 ef                	jne    80105620 <read_inodeinfo_file.part.3+0x2e0>
80105631:	e9 2d fe ff ff       	jmp    80105463 <read_inodeinfo_file.part.3+0x123>
80105636:	8d 76 00             	lea    0x0(%esi),%esi
80105639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    strcpy(data + strlen(data), "FILE");
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	53                   	push   %ebx
80105644:	e8 47 07 00 00       	call   80105d90 <strlen>
80105649:	83 c4 10             	add    $0x10,%esp
8010564c:	01 d8                	add    %ebx,%eax
8010564e:	31 d2                	xor    %edx,%edx
  while((*s++ = *t++) != 0)
80105650:	0f b6 8a fd 8d 10 80 	movzbl -0x7fef7203(%edx),%ecx
80105657:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010565a:	83 c2 01             	add    $0x1,%edx
8010565d:	84 c9                	test   %cl,%cl
8010565f:	75 ef                	jne    80105650 <read_inodeinfo_file.part.3+0x310>
80105661:	0f b7 46 50          	movzwl 0x50(%esi),%eax
80105665:	e9 ef fd ff ff       	jmp    80105459 <read_inodeinfo_file.part.3+0x119>
8010566a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    strcpy(data + strlen(data), "DIR");
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	53                   	push   %ebx
80105674:	e8 17 07 00 00       	call   80105d90 <strlen>
80105679:	83 c4 10             	add    $0x10,%esp
8010567c:	01 d8                	add    %ebx,%eax
8010567e:	31 d2                	xor    %edx,%edx
  while((*s++ = *t++) != 0)
80105680:	0f b6 8a 55 87 10 80 	movzbl -0x7fef78ab(%edx),%ecx
80105687:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010568a:	83 c2 01             	add    $0x1,%edx
8010568d:	84 c9                	test   %cl,%cl
8010568f:	75 ef                	jne    80105680 <read_inodeinfo_file.part.3+0x340>
80105691:	0f b7 46 50          	movzwl 0x50(%esi),%eax
80105695:	e9 b5 fd ff ff       	jmp    8010544f <read_inodeinfo_file.part.3+0x10f>
8010569a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801056a0 <read_inodeinfo_file>:
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	53                   	push   %ebx
801056a4:	8b 5d 14             	mov    0x14(%ebp),%ebx
801056a7:	8b 45 08             	mov    0x8(%ebp),%eax
801056aa:	8b 55 0c             	mov    0xc(%ebp),%edx
801056ad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if (n == sizeof(struct dirent))
801056b0:	83 fb 10             	cmp    $0x10,%ebx
801056b3:	74 0b                	je     801056c0 <read_inodeinfo_file+0x20>
801056b5:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801056b8:	5b                   	pop    %ebx
801056b9:	5d                   	pop    %ebp
801056ba:	e9 81 fc ff ff       	jmp    80105340 <read_inodeinfo_file.part.3>
801056bf:	90                   	nop
801056c0:	31 c0                	xor    %eax,%eax
801056c2:	5b                   	pop    %ebx
801056c3:	5d                   	pop    %ebp
801056c4:	c3                   	ret    
801056c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056d0 <read_path_level_2>:
{
801056d0:	55                   	push   %ebp
  switch (ip->inum/100) {
801056d1:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
{
801056d6:	89 e5                	mov    %esp,%ebp
801056d8:	57                   	push   %edi
801056d9:	56                   	push   %esi
801056da:	53                   	push   %ebx
801056db:	83 ec 1c             	sub    $0x1c,%esp
801056de:	8b 75 08             	mov    0x8(%ebp),%esi
801056e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801056e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
801056e7:	8b 7d 14             	mov    0x14(%ebp),%edi
  switch (ip->inum/100) {
801056ea:	8b 5e 04             	mov    0x4(%esi),%ebx
{
801056ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  switch (ip->inum/100) {
801056f0:	89 d8                	mov    %ebx,%eax
801056f2:	f7 e2                	mul    %edx
801056f4:	c1 ea 05             	shr    $0x5,%edx
801056f7:	83 fa 08             	cmp    $0x8,%edx
801056fa:	74 5c                	je     80105758 <read_path_level_2+0x88>
801056fc:	83 fa 09             	cmp    $0x9,%edx
801056ff:	74 37                	je     80105738 <read_path_level_2+0x68>
80105701:	83 fa 07             	cmp    $0x7,%edx
80105704:	74 22                	je     80105728 <read_path_level_2+0x58>
      cprintf("level 2 no case for inum=%d\n", ip->inum);
80105706:	83 ec 08             	sub    $0x8,%esp
80105709:	53                   	push   %ebx
8010570a:	68 36 8e 10 80       	push   $0x80108e36
8010570f:	e8 4c af ff ff       	call   80100660 <cprintf>
	return 0;
80105714:	83 c4 10             	add    $0x10,%esp
}
80105717:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010571a:	31 c0                	xor    %eax,%eax
8010571c:	5b                   	pop    %ebx
8010571d:	5e                   	pop    %esi
8010571e:	5f                   	pop    %edi
8010571f:	5d                   	pop    %ebp
80105720:	c3                   	ret    
80105721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105728:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010572b:	5b                   	pop    %ebx
8010572c:	5e                   	pop    %esi
8010572d:	5f                   	pop    %edi
8010572e:	5d                   	pop    %ebp
      return read_procfs_name(ip, dst, off, n);
8010572f:	e9 4c f0 ff ff       	jmp    80104780 <read_procfs_name>
80105734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (n == sizeof(struct dirent))
80105738:	83 ff 10             	cmp    $0x10,%edi
8010573b:	74 da                	je     80105717 <read_path_level_2+0x47>
8010573d:	89 7d 08             	mov    %edi,0x8(%ebp)
80105740:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80105743:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105746:	89 f0                	mov    %esi,%eax
80105748:	5b                   	pop    %ebx
80105749:	5e                   	pop    %esi
8010574a:	5f                   	pop    %edi
8010574b:	5d                   	pop    %ebp
8010574c:	e9 ef fb ff ff       	jmp    80105340 <read_inodeinfo_file.part.3>
80105751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105758:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010575b:	5b                   	pop    %ebx
8010575c:	5e                   	pop    %esi
8010575d:	5f                   	pop    %edi
8010575e:	5d                   	pop    %ebp
      return read_procfs_status(ip, dst, off, n);
8010575f:	e9 0c ef ff ff       	jmp    80104670 <read_procfs_status>
80105764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010576a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105770 <procfsread>:
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	83 ec 08             	sub    $0x8,%esp
  switch (ip->minor){
80105776:	8b 45 08             	mov    0x8(%ebp),%eax
80105779:	0f bf 40 54          	movswl 0x54(%eax),%eax
8010577d:	66 83 f8 01          	cmp    $0x1,%ax
80105781:	74 5d                	je     801057e0 <procfsread+0x70>
80105783:	7e 2b                	jle    801057b0 <procfsread+0x40>
80105785:	66 83 f8 02          	cmp    $0x2,%ax
80105789:	74 1d                	je     801057a8 <procfsread+0x38>
8010578b:	66 83 f8 03          	cmp    $0x3,%ax
8010578f:	75 2f                	jne    801057c0 <procfsread+0x50>
      cprintf("case 3\n");
80105791:	83 ec 0c             	sub    $0xc,%esp
80105794:	68 53 8e 10 80       	push   $0x80108e53
80105799:	e8 c2 ae ff ff       	call   80100660 <cprintf>
      return read_path_level_3(ip,dst,off,n);
8010579e:	83 c4 10             	add    $0x10,%esp
801057a1:	31 c0                	xor    %eax,%eax
}
801057a3:	c9                   	leave  
801057a4:	c3                   	ret    
801057a5:	8d 76 00             	lea    0x0(%esi),%esi
801057a8:	c9                   	leave  
      return read_path_level_2(ip,dst,off,n);
801057a9:	e9 22 ff ff ff       	jmp    801056d0 <read_path_level_2>
801057ae:	66 90                	xchg   %ax,%ax
  switch (ip->minor){
801057b0:	66 85 c0             	test   %ax,%ax
801057b3:	75 0b                	jne    801057c0 <procfsread+0x50>
}
801057b5:	c9                   	leave  
      return read_path_level_0(ip,dst,off,n);
801057b6:	e9 45 f4 ff ff       	jmp    80104c00 <read_path_level_0>
801057bb:	90                   	nop
801057bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("procfsread minor: %d", ip->minor);
801057c0:	83 ec 08             	sub    $0x8,%esp
801057c3:	50                   	push   %eax
801057c4:	68 5b 8e 10 80       	push   $0x80108e5b
801057c9:	e8 92 ae ff ff       	call   80100660 <cprintf>
      return -1;
801057ce:	83 c4 10             	add    $0x10,%esp
801057d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057d6:	c9                   	leave  
801057d7:	c3                   	ret    
801057d8:	90                   	nop
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057e0:	c9                   	leave  
      return read_path_level_1(ip,dst,off,n);
801057e1:	e9 ea fa ff ff       	jmp    801052d0 <read_path_level_1>
801057e6:	66 90                	xchg   %ax,%ax
801057e8:	66 90                	xchg   %ax,%ax
801057ea:	66 90                	xchg   %ax,%ax
801057ec:	66 90                	xchg   %ax,%ax
801057ee:	66 90                	xchg   %ax,%ax

801057f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	53                   	push   %ebx
801057f4:	83 ec 0c             	sub    $0xc,%esp
801057f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801057fa:	68 cd 8e 10 80       	push   $0x80108ecd
801057ff:	8d 43 04             	lea    0x4(%ebx),%eax
80105802:	50                   	push   %eax
80105803:	e8 18 01 00 00       	call   80105920 <initlock>
  lk->name = name;
80105808:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010580b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105811:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105814:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010581b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010581e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105821:	c9                   	leave  
80105822:	c3                   	ret    
80105823:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105830 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	56                   	push   %esi
80105834:	53                   	push   %ebx
80105835:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105838:	83 ec 0c             	sub    $0xc,%esp
8010583b:	8d 73 04             	lea    0x4(%ebx),%esi
8010583e:	56                   	push   %esi
8010583f:	e8 1c 02 00 00       	call   80105a60 <acquire>
  while (lk->locked) {
80105844:	8b 13                	mov    (%ebx),%edx
80105846:	83 c4 10             	add    $0x10,%esp
80105849:	85 d2                	test   %edx,%edx
8010584b:	74 16                	je     80105863 <acquiresleep+0x33>
8010584d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105850:	83 ec 08             	sub    $0x8,%esp
80105853:	56                   	push   %esi
80105854:	53                   	push   %ebx
80105855:	e8 d6 e8 ff ff       	call   80104130 <sleep>
  while (lk->locked) {
8010585a:	8b 03                	mov    (%ebx),%eax
8010585c:	83 c4 10             	add    $0x10,%esp
8010585f:	85 c0                	test   %eax,%eax
80105861:	75 ed                	jne    80105850 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105863:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105869:	e8 22 e3 ff ff       	call   80103b90 <myproc>
8010586e:	8b 40 10             	mov    0x10(%eax),%eax
80105871:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105874:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105877:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010587a:	5b                   	pop    %ebx
8010587b:	5e                   	pop    %esi
8010587c:	5d                   	pop    %ebp
  release(&lk->lk);
8010587d:	e9 9e 02 00 00       	jmp    80105b20 <release>
80105882:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105890 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	56                   	push   %esi
80105894:	53                   	push   %ebx
80105895:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105898:	83 ec 0c             	sub    $0xc,%esp
8010589b:	8d 73 04             	lea    0x4(%ebx),%esi
8010589e:	56                   	push   %esi
8010589f:	e8 bc 01 00 00       	call   80105a60 <acquire>
  lk->locked = 0;
801058a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801058aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801058b1:	89 1c 24             	mov    %ebx,(%esp)
801058b4:	e8 27 ea ff ff       	call   801042e0 <wakeup>
  release(&lk->lk);
801058b9:	89 75 08             	mov    %esi,0x8(%ebp)
801058bc:	83 c4 10             	add    $0x10,%esp
}
801058bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058c2:	5b                   	pop    %ebx
801058c3:	5e                   	pop    %esi
801058c4:	5d                   	pop    %ebp
  release(&lk->lk);
801058c5:	e9 56 02 00 00       	jmp    80105b20 <release>
801058ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	57                   	push   %edi
801058d4:	56                   	push   %esi
801058d5:	53                   	push   %ebx
801058d6:	31 ff                	xor    %edi,%edi
801058d8:	83 ec 18             	sub    $0x18,%esp
801058db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801058de:	8d 73 04             	lea    0x4(%ebx),%esi
801058e1:	56                   	push   %esi
801058e2:	e8 79 01 00 00       	call   80105a60 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801058e7:	8b 03                	mov    (%ebx),%eax
801058e9:	83 c4 10             	add    $0x10,%esp
801058ec:	85 c0                	test   %eax,%eax
801058ee:	74 13                	je     80105903 <holdingsleep+0x33>
801058f0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801058f3:	e8 98 e2 ff ff       	call   80103b90 <myproc>
801058f8:	39 58 10             	cmp    %ebx,0x10(%eax)
801058fb:	0f 94 c0             	sete   %al
801058fe:	0f b6 c0             	movzbl %al,%eax
80105901:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80105903:	83 ec 0c             	sub    $0xc,%esp
80105906:	56                   	push   %esi
80105907:	e8 14 02 00 00       	call   80105b20 <release>
  return r;
}
8010590c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010590f:	89 f8                	mov    %edi,%eax
80105911:	5b                   	pop    %ebx
80105912:	5e                   	pop    %esi
80105913:	5f                   	pop    %edi
80105914:	5d                   	pop    %ebp
80105915:	c3                   	ret    
80105916:	66 90                	xchg   %ax,%ax
80105918:	66 90                	xchg   %ax,%ax
8010591a:	66 90                	xchg   %ax,%ax
8010591c:	66 90                	xchg   %ax,%ax
8010591e:	66 90                	xchg   %ax,%ax

80105920 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105926:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105929:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010592f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105932:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105939:	5d                   	pop    %ebp
8010593a:	c3                   	ret    
8010593b:	90                   	nop
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105940:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105941:	31 d2                	xor    %edx,%edx
{
80105943:	89 e5                	mov    %esp,%ebp
80105945:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105946:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105949:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010594c:	83 e8 08             	sub    $0x8,%eax
8010594f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105950:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105956:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010595c:	77 1a                	ja     80105978 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010595e:	8b 58 04             	mov    0x4(%eax),%ebx
80105961:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105964:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105967:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105969:	83 fa 0a             	cmp    $0xa,%edx
8010596c:	75 e2                	jne    80105950 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010596e:	5b                   	pop    %ebx
8010596f:	5d                   	pop    %ebp
80105970:	c3                   	ret    
80105971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105978:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010597b:	83 c1 28             	add    $0x28,%ecx
8010597e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105980:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105986:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105989:	39 c1                	cmp    %eax,%ecx
8010598b:	75 f3                	jne    80105980 <getcallerpcs+0x40>
}
8010598d:	5b                   	pop    %ebx
8010598e:	5d                   	pop    %ebp
8010598f:	c3                   	ret    

80105990 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	53                   	push   %ebx
80105994:	83 ec 04             	sub    $0x4,%esp
80105997:	9c                   	pushf  
80105998:	5b                   	pop    %ebx
  asm volatile("cli");
80105999:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010599a:	e8 51 e1 ff ff       	call   80103af0 <mycpu>
8010599f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801059a5:	85 c0                	test   %eax,%eax
801059a7:	75 11                	jne    801059ba <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801059a9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801059af:	e8 3c e1 ff ff       	call   80103af0 <mycpu>
801059b4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801059ba:	e8 31 e1 ff ff       	call   80103af0 <mycpu>
801059bf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801059c6:	83 c4 04             	add    $0x4,%esp
801059c9:	5b                   	pop    %ebx
801059ca:	5d                   	pop    %ebp
801059cb:	c3                   	ret    
801059cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059d0 <popcli>:

void
popcli(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801059d6:	9c                   	pushf  
801059d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801059d8:	f6 c4 02             	test   $0x2,%ah
801059db:	75 35                	jne    80105a12 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801059dd:	e8 0e e1 ff ff       	call   80103af0 <mycpu>
801059e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801059e9:	78 34                	js     80105a1f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801059eb:	e8 00 e1 ff ff       	call   80103af0 <mycpu>
801059f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801059f6:	85 d2                	test   %edx,%edx
801059f8:	74 06                	je     80105a00 <popcli+0x30>
    sti();
}
801059fa:	c9                   	leave  
801059fb:	c3                   	ret    
801059fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105a00:	e8 eb e0 ff ff       	call   80103af0 <mycpu>
80105a05:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105a0b:	85 c0                	test   %eax,%eax
80105a0d:	74 eb                	je     801059fa <popcli+0x2a>
  asm volatile("sti");
80105a0f:	fb                   	sti    
}
80105a10:	c9                   	leave  
80105a11:	c3                   	ret    
    panic("popcli - interruptible");
80105a12:	83 ec 0c             	sub    $0xc,%esp
80105a15:	68 d8 8e 10 80       	push   $0x80108ed8
80105a1a:	e8 71 a9 ff ff       	call   80100390 <panic>
    panic("popcli");
80105a1f:	83 ec 0c             	sub    $0xc,%esp
80105a22:	68 ef 8e 10 80       	push   $0x80108eef
80105a27:	e8 64 a9 ff ff       	call   80100390 <panic>
80105a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a30 <holding>:
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	56                   	push   %esi
80105a34:	53                   	push   %ebx
80105a35:	8b 75 08             	mov    0x8(%ebp),%esi
80105a38:	31 db                	xor    %ebx,%ebx
  pushcli();
80105a3a:	e8 51 ff ff ff       	call   80105990 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105a3f:	8b 06                	mov    (%esi),%eax
80105a41:	85 c0                	test   %eax,%eax
80105a43:	74 10                	je     80105a55 <holding+0x25>
80105a45:	8b 5e 08             	mov    0x8(%esi),%ebx
80105a48:	e8 a3 e0 ff ff       	call   80103af0 <mycpu>
80105a4d:	39 c3                	cmp    %eax,%ebx
80105a4f:	0f 94 c3             	sete   %bl
80105a52:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80105a55:	e8 76 ff ff ff       	call   801059d0 <popcli>
}
80105a5a:	89 d8                	mov    %ebx,%eax
80105a5c:	5b                   	pop    %ebx
80105a5d:	5e                   	pop    %esi
80105a5e:	5d                   	pop    %ebp
80105a5f:	c3                   	ret    

80105a60 <acquire>:
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	56                   	push   %esi
80105a64:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105a65:	e8 26 ff ff ff       	call   80105990 <pushcli>
  if(holding(lk))
80105a6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105a6d:	83 ec 0c             	sub    $0xc,%esp
80105a70:	53                   	push   %ebx
80105a71:	e8 ba ff ff ff       	call   80105a30 <holding>
80105a76:	83 c4 10             	add    $0x10,%esp
80105a79:	85 c0                	test   %eax,%eax
80105a7b:	0f 85 83 00 00 00    	jne    80105b04 <acquire+0xa4>
80105a81:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105a83:	ba 01 00 00 00       	mov    $0x1,%edx
80105a88:	eb 09                	jmp    80105a93 <acquire+0x33>
80105a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a90:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105a93:	89 d0                	mov    %edx,%eax
80105a95:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105a98:	85 c0                	test   %eax,%eax
80105a9a:	75 f4                	jne    80105a90 <acquire+0x30>
  __sync_synchronize();
80105a9c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105aa1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105aa4:	e8 47 e0 ff ff       	call   80103af0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105aa9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80105aac:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80105aaf:	89 e8                	mov    %ebp,%eax
80105ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105ab8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80105abe:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80105ac4:	77 1a                	ja     80105ae0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80105ac6:	8b 48 04             	mov    0x4(%eax),%ecx
80105ac9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80105acc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80105acf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105ad1:	83 fe 0a             	cmp    $0xa,%esi
80105ad4:	75 e2                	jne    80105ab8 <acquire+0x58>
}
80105ad6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ad9:	5b                   	pop    %ebx
80105ada:	5e                   	pop    %esi
80105adb:	5d                   	pop    %ebp
80105adc:	c3                   	ret    
80105add:	8d 76 00             	lea    0x0(%esi),%esi
80105ae0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80105ae3:	83 c2 28             	add    $0x28,%edx
80105ae6:	8d 76 00             	lea    0x0(%esi),%esi
80105ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80105af0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105af6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105af9:	39 d0                	cmp    %edx,%eax
80105afb:	75 f3                	jne    80105af0 <acquire+0x90>
}
80105afd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b00:	5b                   	pop    %ebx
80105b01:	5e                   	pop    %esi
80105b02:	5d                   	pop    %ebp
80105b03:	c3                   	ret    
    panic("acquire");
80105b04:	83 ec 0c             	sub    $0xc,%esp
80105b07:	68 f6 8e 10 80       	push   $0x80108ef6
80105b0c:	e8 7f a8 ff ff       	call   80100390 <panic>
80105b11:	eb 0d                	jmp    80105b20 <release>
80105b13:	90                   	nop
80105b14:	90                   	nop
80105b15:	90                   	nop
80105b16:	90                   	nop
80105b17:	90                   	nop
80105b18:	90                   	nop
80105b19:	90                   	nop
80105b1a:	90                   	nop
80105b1b:	90                   	nop
80105b1c:	90                   	nop
80105b1d:	90                   	nop
80105b1e:	90                   	nop
80105b1f:	90                   	nop

80105b20 <release>:
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	53                   	push   %ebx
80105b24:	83 ec 10             	sub    $0x10,%esp
80105b27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80105b2a:	53                   	push   %ebx
80105b2b:	e8 00 ff ff ff       	call   80105a30 <holding>
80105b30:	83 c4 10             	add    $0x10,%esp
80105b33:	85 c0                	test   %eax,%eax
80105b35:	74 22                	je     80105b59 <release+0x39>
  lk->pcs[0] = 0;
80105b37:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105b3e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105b45:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105b4a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105b50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b53:	c9                   	leave  
  popcli();
80105b54:	e9 77 fe ff ff       	jmp    801059d0 <popcli>
    panic("release");
80105b59:	83 ec 0c             	sub    $0xc,%esp
80105b5c:	68 fe 8e 10 80       	push   $0x80108efe
80105b61:	e8 2a a8 ff ff       	call   80100390 <panic>
80105b66:	66 90                	xchg   %ax,%ax
80105b68:	66 90                	xchg   %ax,%ax
80105b6a:	66 90                	xchg   %ax,%ax
80105b6c:	66 90                	xchg   %ax,%ax
80105b6e:	66 90                	xchg   %ax,%ax

80105b70 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	57                   	push   %edi
80105b74:	53                   	push   %ebx
80105b75:	8b 55 08             	mov    0x8(%ebp),%edx
80105b78:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80105b7b:	f6 c2 03             	test   $0x3,%dl
80105b7e:	75 05                	jne    80105b85 <memset+0x15>
80105b80:	f6 c1 03             	test   $0x3,%cl
80105b83:	74 13                	je     80105b98 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105b85:	89 d7                	mov    %edx,%edi
80105b87:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b8a:	fc                   	cld    
80105b8b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80105b8d:	5b                   	pop    %ebx
80105b8e:	89 d0                	mov    %edx,%eax
80105b90:	5f                   	pop    %edi
80105b91:	5d                   	pop    %ebp
80105b92:	c3                   	ret    
80105b93:	90                   	nop
80105b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105b98:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105b9c:	c1 e9 02             	shr    $0x2,%ecx
80105b9f:	89 f8                	mov    %edi,%eax
80105ba1:	89 fb                	mov    %edi,%ebx
80105ba3:	c1 e0 18             	shl    $0x18,%eax
80105ba6:	c1 e3 10             	shl    $0x10,%ebx
80105ba9:	09 d8                	or     %ebx,%eax
80105bab:	09 f8                	or     %edi,%eax
80105bad:	c1 e7 08             	shl    $0x8,%edi
80105bb0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105bb2:	89 d7                	mov    %edx,%edi
80105bb4:	fc                   	cld    
80105bb5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105bb7:	5b                   	pop    %ebx
80105bb8:	89 d0                	mov    %edx,%eax
80105bba:	5f                   	pop    %edi
80105bbb:	5d                   	pop    %ebp
80105bbc:	c3                   	ret    
80105bbd:	8d 76 00             	lea    0x0(%esi),%esi

80105bc0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	57                   	push   %edi
80105bc4:	56                   	push   %esi
80105bc5:	53                   	push   %ebx
80105bc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105bc9:	8b 75 08             	mov    0x8(%ebp),%esi
80105bcc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105bcf:	85 db                	test   %ebx,%ebx
80105bd1:	74 29                	je     80105bfc <memcmp+0x3c>
    if(*s1 != *s2)
80105bd3:	0f b6 16             	movzbl (%esi),%edx
80105bd6:	0f b6 0f             	movzbl (%edi),%ecx
80105bd9:	38 d1                	cmp    %dl,%cl
80105bdb:	75 2b                	jne    80105c08 <memcmp+0x48>
80105bdd:	b8 01 00 00 00       	mov    $0x1,%eax
80105be2:	eb 14                	jmp    80105bf8 <memcmp+0x38>
80105be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105be8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80105bec:	83 c0 01             	add    $0x1,%eax
80105bef:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105bf4:	38 ca                	cmp    %cl,%dl
80105bf6:	75 10                	jne    80105c08 <memcmp+0x48>
  while(n-- > 0){
80105bf8:	39 d8                	cmp    %ebx,%eax
80105bfa:	75 ec                	jne    80105be8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80105bfc:	5b                   	pop    %ebx
  return 0;
80105bfd:	31 c0                	xor    %eax,%eax
}
80105bff:	5e                   	pop    %esi
80105c00:	5f                   	pop    %edi
80105c01:	5d                   	pop    %ebp
80105c02:	c3                   	ret    
80105c03:	90                   	nop
80105c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105c08:	0f b6 c2             	movzbl %dl,%eax
}
80105c0b:	5b                   	pop    %ebx
      return *s1 - *s2;
80105c0c:	29 c8                	sub    %ecx,%eax
}
80105c0e:	5e                   	pop    %esi
80105c0f:	5f                   	pop    %edi
80105c10:	5d                   	pop    %ebp
80105c11:	c3                   	ret    
80105c12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c20 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	56                   	push   %esi
80105c24:	53                   	push   %ebx
80105c25:	8b 45 08             	mov    0x8(%ebp),%eax
80105c28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80105c2b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105c2e:	39 c3                	cmp    %eax,%ebx
80105c30:	73 26                	jae    80105c58 <memmove+0x38>
80105c32:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105c35:	39 c8                	cmp    %ecx,%eax
80105c37:	73 1f                	jae    80105c58 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105c39:	85 f6                	test   %esi,%esi
80105c3b:	8d 56 ff             	lea    -0x1(%esi),%edx
80105c3e:	74 0f                	je     80105c4f <memmove+0x2f>
      *--d = *--s;
80105c40:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105c44:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105c47:	83 ea 01             	sub    $0x1,%edx
80105c4a:	83 fa ff             	cmp    $0xffffffff,%edx
80105c4d:	75 f1                	jne    80105c40 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105c4f:	5b                   	pop    %ebx
80105c50:	5e                   	pop    %esi
80105c51:	5d                   	pop    %ebp
80105c52:	c3                   	ret    
80105c53:	90                   	nop
80105c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105c58:	31 d2                	xor    %edx,%edx
80105c5a:	85 f6                	test   %esi,%esi
80105c5c:	74 f1                	je     80105c4f <memmove+0x2f>
80105c5e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105c60:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105c64:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105c67:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80105c6a:	39 d6                	cmp    %edx,%esi
80105c6c:	75 f2                	jne    80105c60 <memmove+0x40>
}
80105c6e:	5b                   	pop    %ebx
80105c6f:	5e                   	pop    %esi
80105c70:	5d                   	pop    %ebp
80105c71:	c3                   	ret    
80105c72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105c83:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105c84:	eb 9a                	jmp    80105c20 <memmove>
80105c86:	8d 76 00             	lea    0x0(%esi),%esi
80105c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c90 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	57                   	push   %edi
80105c94:	56                   	push   %esi
80105c95:	8b 7d 10             	mov    0x10(%ebp),%edi
80105c98:	53                   	push   %ebx
80105c99:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105c9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80105c9f:	85 ff                	test   %edi,%edi
80105ca1:	74 2f                	je     80105cd2 <strncmp+0x42>
80105ca3:	0f b6 01             	movzbl (%ecx),%eax
80105ca6:	0f b6 1e             	movzbl (%esi),%ebx
80105ca9:	84 c0                	test   %al,%al
80105cab:	74 37                	je     80105ce4 <strncmp+0x54>
80105cad:	38 c3                	cmp    %al,%bl
80105caf:	75 33                	jne    80105ce4 <strncmp+0x54>
80105cb1:	01 f7                	add    %esi,%edi
80105cb3:	eb 13                	jmp    80105cc8 <strncmp+0x38>
80105cb5:	8d 76 00             	lea    0x0(%esi),%esi
80105cb8:	0f b6 01             	movzbl (%ecx),%eax
80105cbb:	84 c0                	test   %al,%al
80105cbd:	74 21                	je     80105ce0 <strncmp+0x50>
80105cbf:	0f b6 1a             	movzbl (%edx),%ebx
80105cc2:	89 d6                	mov    %edx,%esi
80105cc4:	38 d8                	cmp    %bl,%al
80105cc6:	75 1c                	jne    80105ce4 <strncmp+0x54>
    n--, p++, q++;
80105cc8:	8d 56 01             	lea    0x1(%esi),%edx
80105ccb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80105cce:	39 fa                	cmp    %edi,%edx
80105cd0:	75 e6                	jne    80105cb8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105cd2:	5b                   	pop    %ebx
    return 0;
80105cd3:	31 c0                	xor    %eax,%eax
}
80105cd5:	5e                   	pop    %esi
80105cd6:	5f                   	pop    %edi
80105cd7:	5d                   	pop    %ebp
80105cd8:	c3                   	ret    
80105cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ce0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105ce4:	29 d8                	sub    %ebx,%eax
}
80105ce6:	5b                   	pop    %ebx
80105ce7:	5e                   	pop    %esi
80105ce8:	5f                   	pop    %edi
80105ce9:	5d                   	pop    %ebp
80105cea:	c3                   	ret    
80105ceb:	90                   	nop
80105cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cf0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	56                   	push   %esi
80105cf4:	53                   	push   %ebx
80105cf5:	8b 45 08             	mov    0x8(%ebp),%eax
80105cf8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80105cfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105cfe:	89 c2                	mov    %eax,%edx
80105d00:	eb 19                	jmp    80105d1b <strncpy+0x2b>
80105d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d08:	83 c3 01             	add    $0x1,%ebx
80105d0b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80105d0f:	83 c2 01             	add    $0x1,%edx
80105d12:	84 c9                	test   %cl,%cl
80105d14:	88 4a ff             	mov    %cl,-0x1(%edx)
80105d17:	74 09                	je     80105d22 <strncpy+0x32>
80105d19:	89 f1                	mov    %esi,%ecx
80105d1b:	85 c9                	test   %ecx,%ecx
80105d1d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105d20:	7f e6                	jg     80105d08 <strncpy+0x18>
    ;
  while(n-- > 0)
80105d22:	31 c9                	xor    %ecx,%ecx
80105d24:	85 f6                	test   %esi,%esi
80105d26:	7e 17                	jle    80105d3f <strncpy+0x4f>
80105d28:	90                   	nop
80105d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105d30:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105d34:	89 f3                	mov    %esi,%ebx
80105d36:	83 c1 01             	add    $0x1,%ecx
80105d39:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80105d3b:	85 db                	test   %ebx,%ebx
80105d3d:	7f f1                	jg     80105d30 <strncpy+0x40>
  return os;
}
80105d3f:	5b                   	pop    %ebx
80105d40:	5e                   	pop    %esi
80105d41:	5d                   	pop    %ebp
80105d42:	c3                   	ret    
80105d43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	56                   	push   %esi
80105d54:	53                   	push   %ebx
80105d55:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105d58:	8b 45 08             	mov    0x8(%ebp),%eax
80105d5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80105d5e:	85 c9                	test   %ecx,%ecx
80105d60:	7e 26                	jle    80105d88 <safestrcpy+0x38>
80105d62:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105d66:	89 c1                	mov    %eax,%ecx
80105d68:	eb 17                	jmp    80105d81 <safestrcpy+0x31>
80105d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105d70:	83 c2 01             	add    $0x1,%edx
80105d73:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105d77:	83 c1 01             	add    $0x1,%ecx
80105d7a:	84 db                	test   %bl,%bl
80105d7c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80105d7f:	74 04                	je     80105d85 <safestrcpy+0x35>
80105d81:	39 f2                	cmp    %esi,%edx
80105d83:	75 eb                	jne    80105d70 <safestrcpy+0x20>
    ;
  *s = 0;
80105d85:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105d88:	5b                   	pop    %ebx
80105d89:	5e                   	pop    %esi
80105d8a:	5d                   	pop    %ebp
80105d8b:	c3                   	ret    
80105d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d90 <strlen>:

int
strlen(const char *s)
{
80105d90:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105d91:	31 c0                	xor    %eax,%eax
{
80105d93:	89 e5                	mov    %esp,%ebp
80105d95:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105d98:	80 3a 00             	cmpb   $0x0,(%edx)
80105d9b:	74 0c                	je     80105da9 <strlen+0x19>
80105d9d:	8d 76 00             	lea    0x0(%esi),%esi
80105da0:	83 c0 01             	add    $0x1,%eax
80105da3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105da7:	75 f7                	jne    80105da0 <strlen+0x10>
    ;
  return n;
}
80105da9:	5d                   	pop    %ebp
80105daa:	c3                   	ret    

80105dab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105dab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105daf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105db3:	55                   	push   %ebp
  pushl %ebx
80105db4:	53                   	push   %ebx
  pushl %esi
80105db5:	56                   	push   %esi
  pushl %edi
80105db6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105db7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105db9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105dbb:	5f                   	pop    %edi
  popl %esi
80105dbc:	5e                   	pop    %esi
  popl %ebx
80105dbd:	5b                   	pop    %ebx
  popl %ebp
80105dbe:	5d                   	pop    %ebp
  ret
80105dbf:	c3                   	ret    

80105dc0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	53                   	push   %ebx
80105dc4:	83 ec 04             	sub    $0x4,%esp
80105dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105dca:	e8 c1 dd ff ff       	call   80103b90 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105dcf:	8b 00                	mov    (%eax),%eax
80105dd1:	39 d8                	cmp    %ebx,%eax
80105dd3:	76 1b                	jbe    80105df0 <fetchint+0x30>
80105dd5:	8d 53 04             	lea    0x4(%ebx),%edx
80105dd8:	39 d0                	cmp    %edx,%eax
80105dda:	72 14                	jb     80105df0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ddf:	8b 13                	mov    (%ebx),%edx
80105de1:	89 10                	mov    %edx,(%eax)
  return 0;
80105de3:	31 c0                	xor    %eax,%eax
}
80105de5:	83 c4 04             	add    $0x4,%esp
80105de8:	5b                   	pop    %ebx
80105de9:	5d                   	pop    %ebp
80105dea:	c3                   	ret    
80105deb:	90                   	nop
80105dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105df5:	eb ee                	jmp    80105de5 <fetchint+0x25>
80105df7:	89 f6                	mov    %esi,%esi
80105df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e00 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	53                   	push   %ebx
80105e04:	83 ec 04             	sub    $0x4,%esp
80105e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105e0a:	e8 81 dd ff ff       	call   80103b90 <myproc>

  if(addr >= curproc->sz)
80105e0f:	39 18                	cmp    %ebx,(%eax)
80105e11:	76 29                	jbe    80105e3c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105e13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105e16:	89 da                	mov    %ebx,%edx
80105e18:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80105e1a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80105e1c:	39 c3                	cmp    %eax,%ebx
80105e1e:	73 1c                	jae    80105e3c <fetchstr+0x3c>
    if(*s == 0)
80105e20:	80 3b 00             	cmpb   $0x0,(%ebx)
80105e23:	75 10                	jne    80105e35 <fetchstr+0x35>
80105e25:	eb 39                	jmp    80105e60 <fetchstr+0x60>
80105e27:	89 f6                	mov    %esi,%esi
80105e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105e30:	80 3a 00             	cmpb   $0x0,(%edx)
80105e33:	74 1b                	je     80105e50 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105e35:	83 c2 01             	add    $0x1,%edx
80105e38:	39 d0                	cmp    %edx,%eax
80105e3a:	77 f4                	ja     80105e30 <fetchstr+0x30>
    return -1;
80105e3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105e41:	83 c4 04             	add    $0x4,%esp
80105e44:	5b                   	pop    %ebx
80105e45:	5d                   	pop    %ebp
80105e46:	c3                   	ret    
80105e47:	89 f6                	mov    %esi,%esi
80105e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105e50:	83 c4 04             	add    $0x4,%esp
80105e53:	89 d0                	mov    %edx,%eax
80105e55:	29 d8                	sub    %ebx,%eax
80105e57:	5b                   	pop    %ebx
80105e58:	5d                   	pop    %ebp
80105e59:	c3                   	ret    
80105e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105e60:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105e62:	eb dd                	jmp    80105e41 <fetchstr+0x41>
80105e64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105e70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	56                   	push   %esi
80105e74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105e75:	e8 16 dd ff ff       	call   80103b90 <myproc>
80105e7a:	8b 40 18             	mov    0x18(%eax),%eax
80105e7d:	8b 55 08             	mov    0x8(%ebp),%edx
80105e80:	8b 40 44             	mov    0x44(%eax),%eax
80105e83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105e86:	e8 05 dd ff ff       	call   80103b90 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105e8b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105e8d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105e90:	39 c6                	cmp    %eax,%esi
80105e92:	73 1c                	jae    80105eb0 <argint+0x40>
80105e94:	8d 53 08             	lea    0x8(%ebx),%edx
80105e97:	39 d0                	cmp    %edx,%eax
80105e99:	72 15                	jb     80105eb0 <argint+0x40>
  *ip = *(int*)(addr);
80105e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e9e:	8b 53 04             	mov    0x4(%ebx),%edx
80105ea1:	89 10                	mov    %edx,(%eax)
  return 0;
80105ea3:	31 c0                	xor    %eax,%eax
}
80105ea5:	5b                   	pop    %ebx
80105ea6:	5e                   	pop    %esi
80105ea7:	5d                   	pop    %ebp
80105ea8:	c3                   	ret    
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105eb5:	eb ee                	jmp    80105ea5 <argint+0x35>
80105eb7:	89 f6                	mov    %esi,%esi
80105eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ec0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105ec0:	55                   	push   %ebp
80105ec1:	89 e5                	mov    %esp,%ebp
80105ec3:	56                   	push   %esi
80105ec4:	53                   	push   %ebx
80105ec5:	83 ec 10             	sub    $0x10,%esp
80105ec8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80105ecb:	e8 c0 dc ff ff       	call   80103b90 <myproc>
80105ed0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105ed2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ed5:	83 ec 08             	sub    $0x8,%esp
80105ed8:	50                   	push   %eax
80105ed9:	ff 75 08             	pushl  0x8(%ebp)
80105edc:	e8 8f ff ff ff       	call   80105e70 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105ee1:	83 c4 10             	add    $0x10,%esp
80105ee4:	85 c0                	test   %eax,%eax
80105ee6:	78 28                	js     80105f10 <argptr+0x50>
80105ee8:	85 db                	test   %ebx,%ebx
80105eea:	78 24                	js     80105f10 <argptr+0x50>
80105eec:	8b 16                	mov    (%esi),%edx
80105eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef1:	39 c2                	cmp    %eax,%edx
80105ef3:	76 1b                	jbe    80105f10 <argptr+0x50>
80105ef5:	01 c3                	add    %eax,%ebx
80105ef7:	39 da                	cmp    %ebx,%edx
80105ef9:	72 15                	jb     80105f10 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80105efb:	8b 55 0c             	mov    0xc(%ebp),%edx
80105efe:	89 02                	mov    %eax,(%edx)
  return 0;
80105f00:	31 c0                	xor    %eax,%eax
}
80105f02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f05:	5b                   	pop    %ebx
80105f06:	5e                   	pop    %esi
80105f07:	5d                   	pop    %ebp
80105f08:	c3                   	ret    
80105f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f15:	eb eb                	jmp    80105f02 <argptr+0x42>
80105f17:	89 f6                	mov    %esi,%esi
80105f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105f26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f29:	50                   	push   %eax
80105f2a:	ff 75 08             	pushl  0x8(%ebp)
80105f2d:	e8 3e ff ff ff       	call   80105e70 <argint>
80105f32:	83 c4 10             	add    $0x10,%esp
80105f35:	85 c0                	test   %eax,%eax
80105f37:	78 17                	js     80105f50 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105f39:	83 ec 08             	sub    $0x8,%esp
80105f3c:	ff 75 0c             	pushl  0xc(%ebp)
80105f3f:	ff 75 f4             	pushl  -0xc(%ebp)
80105f42:	e8 b9 fe ff ff       	call   80105e00 <fetchstr>
80105f47:	83 c4 10             	add    $0x10,%esp
}
80105f4a:	c9                   	leave  
80105f4b:	c3                   	ret    
80105f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f55:	c9                   	leave  
80105f56:	c3                   	ret    
80105f57:	89 f6                	mov    %esi,%esi
80105f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f60 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	53                   	push   %ebx
80105f64:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105f67:	e8 24 dc ff ff       	call   80103b90 <myproc>
80105f6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105f6e:	8b 40 18             	mov    0x18(%eax),%eax
80105f71:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105f74:	8d 50 ff             	lea    -0x1(%eax),%edx
80105f77:	83 fa 14             	cmp    $0x14,%edx
80105f7a:	77 1c                	ja     80105f98 <syscall+0x38>
80105f7c:	8b 14 85 40 8f 10 80 	mov    -0x7fef70c0(,%eax,4),%edx
80105f83:	85 d2                	test   %edx,%edx
80105f85:	74 11                	je     80105f98 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105f87:	ff d2                	call   *%edx
80105f89:	8b 53 18             	mov    0x18(%ebx),%edx
80105f8c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105f8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f92:	c9                   	leave  
80105f93:	c3                   	ret    
80105f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105f98:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105f99:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105f9c:	50                   	push   %eax
80105f9d:	ff 73 10             	pushl  0x10(%ebx)
80105fa0:	68 06 8f 10 80       	push   $0x80108f06
80105fa5:	e8 b6 a6 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80105faa:	8b 43 18             	mov    0x18(%ebx),%eax
80105fad:	83 c4 10             	add    $0x10,%esp
80105fb0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105fb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fba:	c9                   	leave  
80105fbb:	c3                   	ret    
80105fbc:	66 90                	xchg   %ax,%ax
80105fbe:	66 90                	xchg   %ax,%ax

80105fc0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	57                   	push   %edi
80105fc4:	56                   	push   %esi
80105fc5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105fc6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105fc9:	83 ec 44             	sub    $0x44,%esp
80105fcc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80105fcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105fd2:	56                   	push   %esi
80105fd3:	50                   	push   %eax
{
80105fd4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105fd7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105fda:	e8 61 c1 ff ff       	call   80102140 <nameiparent>
80105fdf:	83 c4 10             	add    $0x10,%esp
80105fe2:	85 c0                	test   %eax,%eax
80105fe4:	0f 84 46 01 00 00    	je     80106130 <create+0x170>
    return 0;
  ilock(dp);
80105fea:	83 ec 0c             	sub    $0xc,%esp
80105fed:	89 c3                	mov    %eax,%ebx
80105fef:	50                   	push   %eax
80105ff0:	e8 3b b8 ff ff       	call   80101830 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105ff5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105ff8:	83 c4 0c             	add    $0xc,%esp
80105ffb:	50                   	push   %eax
80105ffc:	56                   	push   %esi
80105ffd:	53                   	push   %ebx
80105ffe:	e8 5d bd ff ff       	call   80101d60 <dirlookup>
80106003:	83 c4 10             	add    $0x10,%esp
80106006:	85 c0                	test   %eax,%eax
80106008:	89 c7                	mov    %eax,%edi
8010600a:	74 34                	je     80106040 <create+0x80>
    iunlockput(dp);
8010600c:	83 ec 0c             	sub    $0xc,%esp
8010600f:	53                   	push   %ebx
80106010:	e8 ab ba ff ff       	call   80101ac0 <iunlockput>
    ilock(ip);
80106015:	89 3c 24             	mov    %edi,(%esp)
80106018:	e8 13 b8 ff ff       	call   80101830 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010601d:	83 c4 10             	add    $0x10,%esp
80106020:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80106025:	0f 85 95 00 00 00    	jne    801060c0 <create+0x100>
8010602b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80106030:	0f 85 8a 00 00 00    	jne    801060c0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80106036:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106039:	89 f8                	mov    %edi,%eax
8010603b:	5b                   	pop    %ebx
8010603c:	5e                   	pop    %esi
8010603d:	5f                   	pop    %edi
8010603e:	5d                   	pop    %ebp
8010603f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80106040:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80106044:	83 ec 08             	sub    $0x8,%esp
80106047:	50                   	push   %eax
80106048:	ff 33                	pushl  (%ebx)
8010604a:	e8 71 b6 ff ff       	call   801016c0 <ialloc>
8010604f:	83 c4 10             	add    $0x10,%esp
80106052:	85 c0                	test   %eax,%eax
80106054:	89 c7                	mov    %eax,%edi
80106056:	0f 84 e8 00 00 00    	je     80106144 <create+0x184>
  ilock(ip);
8010605c:	83 ec 0c             	sub    $0xc,%esp
8010605f:	50                   	push   %eax
80106060:	e8 cb b7 ff ff       	call   80101830 <ilock>
  ip->major = major;
80106065:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80106069:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010606d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80106071:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80106075:	b8 01 00 00 00       	mov    $0x1,%eax
8010607a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010607e:	89 3c 24             	mov    %edi,(%esp)
80106081:	e8 fa b6 ff ff       	call   80101780 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80106086:	83 c4 10             	add    $0x10,%esp
80106089:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010608e:	74 50                	je     801060e0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80106090:	83 ec 04             	sub    $0x4,%esp
80106093:	ff 77 04             	pushl  0x4(%edi)
80106096:	56                   	push   %esi
80106097:	53                   	push   %ebx
80106098:	e8 c3 bf ff ff       	call   80102060 <dirlink>
8010609d:	83 c4 10             	add    $0x10,%esp
801060a0:	85 c0                	test   %eax,%eax
801060a2:	0f 88 8f 00 00 00    	js     80106137 <create+0x177>
  iunlockput(dp);
801060a8:	83 ec 0c             	sub    $0xc,%esp
801060ab:	53                   	push   %ebx
801060ac:	e8 0f ba ff ff       	call   80101ac0 <iunlockput>
  return ip;
801060b1:	83 c4 10             	add    $0x10,%esp
}
801060b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060b7:	89 f8                	mov    %edi,%eax
801060b9:	5b                   	pop    %ebx
801060ba:	5e                   	pop    %esi
801060bb:	5f                   	pop    %edi
801060bc:	5d                   	pop    %ebp
801060bd:	c3                   	ret    
801060be:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801060c0:	83 ec 0c             	sub    $0xc,%esp
801060c3:	57                   	push   %edi
    return 0;
801060c4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801060c6:	e8 f5 b9 ff ff       	call   80101ac0 <iunlockput>
    return 0;
801060cb:	83 c4 10             	add    $0x10,%esp
}
801060ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060d1:	89 f8                	mov    %edi,%eax
801060d3:	5b                   	pop    %ebx
801060d4:	5e                   	pop    %esi
801060d5:	5f                   	pop    %edi
801060d6:	5d                   	pop    %ebp
801060d7:	c3                   	ret    
801060d8:	90                   	nop
801060d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801060e0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801060e5:	83 ec 0c             	sub    $0xc,%esp
801060e8:	53                   	push   %ebx
801060e9:	e8 92 b6 ff ff       	call   80101780 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801060ee:	83 c4 0c             	add    $0xc,%esp
801060f1:	ff 77 04             	pushl  0x4(%edi)
801060f4:	68 89 8c 10 80       	push   $0x80108c89
801060f9:	57                   	push   %edi
801060fa:	e8 61 bf ff ff       	call   80102060 <dirlink>
801060ff:	83 c4 10             	add    $0x10,%esp
80106102:	85 c0                	test   %eax,%eax
80106104:	78 1c                	js     80106122 <create+0x162>
80106106:	83 ec 04             	sub    $0x4,%esp
80106109:	ff 73 04             	pushl  0x4(%ebx)
8010610c:	68 88 8c 10 80       	push   $0x80108c88
80106111:	57                   	push   %edi
80106112:	e8 49 bf ff ff       	call   80102060 <dirlink>
80106117:	83 c4 10             	add    $0x10,%esp
8010611a:	85 c0                	test   %eax,%eax
8010611c:	0f 89 6e ff ff ff    	jns    80106090 <create+0xd0>
      panic("create dots");
80106122:	83 ec 0c             	sub    $0xc,%esp
80106125:	68 a7 8f 10 80       	push   $0x80108fa7
8010612a:	e8 61 a2 ff ff       	call   80100390 <panic>
8010612f:	90                   	nop
    return 0;
80106130:	31 ff                	xor    %edi,%edi
80106132:	e9 ff fe ff ff       	jmp    80106036 <create+0x76>
    panic("create: dirlink");
80106137:	83 ec 0c             	sub    $0xc,%esp
8010613a:	68 b3 8f 10 80       	push   $0x80108fb3
8010613f:	e8 4c a2 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80106144:	83 ec 0c             	sub    $0xc,%esp
80106147:	68 98 8f 10 80       	push   $0x80108f98
8010614c:	e8 3f a2 ff ff       	call   80100390 <panic>
80106151:	eb 0d                	jmp    80106160 <argfd.constprop.0>
80106153:	90                   	nop
80106154:	90                   	nop
80106155:	90                   	nop
80106156:	90                   	nop
80106157:	90                   	nop
80106158:	90                   	nop
80106159:	90                   	nop
8010615a:	90                   	nop
8010615b:	90                   	nop
8010615c:	90                   	nop
8010615d:	90                   	nop
8010615e:	90                   	nop
8010615f:	90                   	nop

80106160 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80106160:	55                   	push   %ebp
80106161:	89 e5                	mov    %esp,%ebp
80106163:	56                   	push   %esi
80106164:	53                   	push   %ebx
80106165:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80106167:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010616a:	89 d6                	mov    %edx,%esi
8010616c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010616f:	50                   	push   %eax
80106170:	6a 00                	push   $0x0
80106172:	e8 f9 fc ff ff       	call   80105e70 <argint>
80106177:	83 c4 10             	add    $0x10,%esp
8010617a:	85 c0                	test   %eax,%eax
8010617c:	78 2a                	js     801061a8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010617e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106182:	77 24                	ja     801061a8 <argfd.constprop.0+0x48>
80106184:	e8 07 da ff ff       	call   80103b90 <myproc>
80106189:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010618c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80106190:	85 c0                	test   %eax,%eax
80106192:	74 14                	je     801061a8 <argfd.constprop.0+0x48>
  if(pfd)
80106194:	85 db                	test   %ebx,%ebx
80106196:	74 02                	je     8010619a <argfd.constprop.0+0x3a>
    *pfd = fd;
80106198:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010619a:	89 06                	mov    %eax,(%esi)
  return 0;
8010619c:	31 c0                	xor    %eax,%eax
}
8010619e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061a1:	5b                   	pop    %ebx
801061a2:	5e                   	pop    %esi
801061a3:	5d                   	pop    %ebp
801061a4:	c3                   	ret    
801061a5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801061a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061ad:	eb ef                	jmp    8010619e <argfd.constprop.0+0x3e>
801061af:	90                   	nop

801061b0 <sys_dup>:
{
801061b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801061b1:	31 c0                	xor    %eax,%eax
{
801061b3:	89 e5                	mov    %esp,%ebp
801061b5:	56                   	push   %esi
801061b6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801061b7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801061ba:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801061bd:	e8 9e ff ff ff       	call   80106160 <argfd.constprop.0>
801061c2:	85 c0                	test   %eax,%eax
801061c4:	78 42                	js     80106208 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801061c6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801061c9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801061cb:	e8 c0 d9 ff ff       	call   80103b90 <myproc>
801061d0:	eb 0e                	jmp    801061e0 <sys_dup+0x30>
801061d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801061d8:	83 c3 01             	add    $0x1,%ebx
801061db:	83 fb 10             	cmp    $0x10,%ebx
801061de:	74 28                	je     80106208 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801061e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801061e4:	85 d2                	test   %edx,%edx
801061e6:	75 f0                	jne    801061d8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801061e8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801061ec:	83 ec 0c             	sub    $0xc,%esp
801061ef:	ff 75 f4             	pushl  -0xc(%ebp)
801061f2:	e8 f9 ab ff ff       	call   80100df0 <filedup>
  return fd;
801061f7:	83 c4 10             	add    $0x10,%esp
}
801061fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061fd:	89 d8                	mov    %ebx,%eax
801061ff:	5b                   	pop    %ebx
80106200:	5e                   	pop    %esi
80106201:	5d                   	pop    %ebp
80106202:	c3                   	ret    
80106203:	90                   	nop
80106204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106208:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010620b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80106210:	89 d8                	mov    %ebx,%eax
80106212:	5b                   	pop    %ebx
80106213:	5e                   	pop    %esi
80106214:	5d                   	pop    %ebp
80106215:	c3                   	ret    
80106216:	8d 76 00             	lea    0x0(%esi),%esi
80106219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106220 <sys_read>:
{
80106220:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106221:	31 c0                	xor    %eax,%eax
{
80106223:	89 e5                	mov    %esp,%ebp
80106225:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106228:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010622b:	e8 30 ff ff ff       	call   80106160 <argfd.constprop.0>
80106230:	85 c0                	test   %eax,%eax
80106232:	78 4c                	js     80106280 <sys_read+0x60>
80106234:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106237:	83 ec 08             	sub    $0x8,%esp
8010623a:	50                   	push   %eax
8010623b:	6a 02                	push   $0x2
8010623d:	e8 2e fc ff ff       	call   80105e70 <argint>
80106242:	83 c4 10             	add    $0x10,%esp
80106245:	85 c0                	test   %eax,%eax
80106247:	78 37                	js     80106280 <sys_read+0x60>
80106249:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010624c:	83 ec 04             	sub    $0x4,%esp
8010624f:	ff 75 f0             	pushl  -0x10(%ebp)
80106252:	50                   	push   %eax
80106253:	6a 01                	push   $0x1
80106255:	e8 66 fc ff ff       	call   80105ec0 <argptr>
8010625a:	83 c4 10             	add    $0x10,%esp
8010625d:	85 c0                	test   %eax,%eax
8010625f:	78 1f                	js     80106280 <sys_read+0x60>
  return fileread(f, p, n);
80106261:	83 ec 04             	sub    $0x4,%esp
80106264:	ff 75 f0             	pushl  -0x10(%ebp)
80106267:	ff 75 f4             	pushl  -0xc(%ebp)
8010626a:	ff 75 ec             	pushl  -0x14(%ebp)
8010626d:	e8 ee ac ff ff       	call   80100f60 <fileread>
80106272:	83 c4 10             	add    $0x10,%esp
}
80106275:	c9                   	leave  
80106276:	c3                   	ret    
80106277:	89 f6                	mov    %esi,%esi
80106279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80106280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106285:	c9                   	leave  
80106286:	c3                   	ret    
80106287:	89 f6                	mov    %esi,%esi
80106289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106290 <sys_write>:
{
80106290:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106291:	31 c0                	xor    %eax,%eax
{
80106293:	89 e5                	mov    %esp,%ebp
80106295:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106298:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010629b:	e8 c0 fe ff ff       	call   80106160 <argfd.constprop.0>
801062a0:	85 c0                	test   %eax,%eax
801062a2:	78 4c                	js     801062f0 <sys_write+0x60>
801062a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062a7:	83 ec 08             	sub    $0x8,%esp
801062aa:	50                   	push   %eax
801062ab:	6a 02                	push   $0x2
801062ad:	e8 be fb ff ff       	call   80105e70 <argint>
801062b2:	83 c4 10             	add    $0x10,%esp
801062b5:	85 c0                	test   %eax,%eax
801062b7:	78 37                	js     801062f0 <sys_write+0x60>
801062b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062bc:	83 ec 04             	sub    $0x4,%esp
801062bf:	ff 75 f0             	pushl  -0x10(%ebp)
801062c2:	50                   	push   %eax
801062c3:	6a 01                	push   $0x1
801062c5:	e8 f6 fb ff ff       	call   80105ec0 <argptr>
801062ca:	83 c4 10             	add    $0x10,%esp
801062cd:	85 c0                	test   %eax,%eax
801062cf:	78 1f                	js     801062f0 <sys_write+0x60>
  return filewrite(f, p, n);
801062d1:	83 ec 04             	sub    $0x4,%esp
801062d4:	ff 75 f0             	pushl  -0x10(%ebp)
801062d7:	ff 75 f4             	pushl  -0xc(%ebp)
801062da:	ff 75 ec             	pushl  -0x14(%ebp)
801062dd:	e8 0e ad ff ff       	call   80100ff0 <filewrite>
801062e2:	83 c4 10             	add    $0x10,%esp
}
801062e5:	c9                   	leave  
801062e6:	c3                   	ret    
801062e7:	89 f6                	mov    %esi,%esi
801062e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801062f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062f5:	c9                   	leave  
801062f6:	c3                   	ret    
801062f7:	89 f6                	mov    %esi,%esi
801062f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106300 <sys_close>:
{
80106300:	55                   	push   %ebp
80106301:	89 e5                	mov    %esp,%ebp
80106303:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80106306:	8d 55 f4             	lea    -0xc(%ebp),%edx
80106309:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010630c:	e8 4f fe ff ff       	call   80106160 <argfd.constprop.0>
80106311:	85 c0                	test   %eax,%eax
80106313:	78 2b                	js     80106340 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80106315:	e8 76 d8 ff ff       	call   80103b90 <myproc>
8010631a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010631d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80106320:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80106327:	00 
  fileclose(f);
80106328:	ff 75 f4             	pushl  -0xc(%ebp)
8010632b:	e8 10 ab ff ff       	call   80100e40 <fileclose>
  return 0;
80106330:	83 c4 10             	add    $0x10,%esp
80106333:	31 c0                	xor    %eax,%eax
}
80106335:	c9                   	leave  
80106336:	c3                   	ret    
80106337:	89 f6                	mov    %esi,%esi
80106339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80106340:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106345:	c9                   	leave  
80106346:	c3                   	ret    
80106347:	89 f6                	mov    %esi,%esi
80106349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106350 <sys_fstat>:
{
80106350:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106351:	31 c0                	xor    %eax,%eax
{
80106353:	89 e5                	mov    %esp,%ebp
80106355:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106358:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010635b:	e8 00 fe ff ff       	call   80106160 <argfd.constprop.0>
80106360:	85 c0                	test   %eax,%eax
80106362:	78 2c                	js     80106390 <sys_fstat+0x40>
80106364:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106367:	83 ec 04             	sub    $0x4,%esp
8010636a:	6a 14                	push   $0x14
8010636c:	50                   	push   %eax
8010636d:	6a 01                	push   $0x1
8010636f:	e8 4c fb ff ff       	call   80105ec0 <argptr>
80106374:	83 c4 10             	add    $0x10,%esp
80106377:	85 c0                	test   %eax,%eax
80106379:	78 15                	js     80106390 <sys_fstat+0x40>
  return filestat(f, st);
8010637b:	83 ec 08             	sub    $0x8,%esp
8010637e:	ff 75 f4             	pushl  -0xc(%ebp)
80106381:	ff 75 f0             	pushl  -0x10(%ebp)
80106384:	e8 87 ab ff ff       	call   80100f10 <filestat>
80106389:	83 c4 10             	add    $0x10,%esp
}
8010638c:	c9                   	leave  
8010638d:	c3                   	ret    
8010638e:	66 90                	xchg   %ax,%ax
    return -1;
80106390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106395:	c9                   	leave  
80106396:	c3                   	ret    
80106397:	89 f6                	mov    %esi,%esi
80106399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063a0 <sys_link>:
{
801063a0:	55                   	push   %ebp
801063a1:	89 e5                	mov    %esp,%ebp
801063a3:	57                   	push   %edi
801063a4:	56                   	push   %esi
801063a5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801063a6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801063a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801063ac:	50                   	push   %eax
801063ad:	6a 00                	push   $0x0
801063af:	e8 6c fb ff ff       	call   80105f20 <argstr>
801063b4:	83 c4 10             	add    $0x10,%esp
801063b7:	85 c0                	test   %eax,%eax
801063b9:	0f 88 fb 00 00 00    	js     801064ba <sys_link+0x11a>
801063bf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801063c2:	83 ec 08             	sub    $0x8,%esp
801063c5:	50                   	push   %eax
801063c6:	6a 01                	push   $0x1
801063c8:	e8 53 fb ff ff       	call   80105f20 <argstr>
801063cd:	83 c4 10             	add    $0x10,%esp
801063d0:	85 c0                	test   %eax,%eax
801063d2:	0f 88 e2 00 00 00    	js     801064ba <sys_link+0x11a>
  begin_op();
801063d8:	e8 63 cb ff ff       	call   80102f40 <begin_op>
  if((ip = namei(old)) == 0){
801063dd:	83 ec 0c             	sub    $0xc,%esp
801063e0:	ff 75 d4             	pushl  -0x2c(%ebp)
801063e3:	e8 38 bd ff ff       	call   80102120 <namei>
801063e8:	83 c4 10             	add    $0x10,%esp
801063eb:	85 c0                	test   %eax,%eax
801063ed:	89 c3                	mov    %eax,%ebx
801063ef:	0f 84 ea 00 00 00    	je     801064df <sys_link+0x13f>
  ilock(ip);
801063f5:	83 ec 0c             	sub    $0xc,%esp
801063f8:	50                   	push   %eax
801063f9:	e8 32 b4 ff ff       	call   80101830 <ilock>
  if(ip->type == T_DIR){
801063fe:	83 c4 10             	add    $0x10,%esp
80106401:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106406:	0f 84 bb 00 00 00    	je     801064c7 <sys_link+0x127>
  ip->nlink++;
8010640c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80106411:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80106414:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80106417:	53                   	push   %ebx
80106418:	e8 63 b3 ff ff       	call   80101780 <iupdate>
  iunlock(ip);
8010641d:	89 1c 24             	mov    %ebx,(%esp)
80106420:	e8 eb b4 ff ff       	call   80101910 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80106425:	58                   	pop    %eax
80106426:	5a                   	pop    %edx
80106427:	57                   	push   %edi
80106428:	ff 75 d0             	pushl  -0x30(%ebp)
8010642b:	e8 10 bd ff ff       	call   80102140 <nameiparent>
80106430:	83 c4 10             	add    $0x10,%esp
80106433:	85 c0                	test   %eax,%eax
80106435:	89 c6                	mov    %eax,%esi
80106437:	74 5b                	je     80106494 <sys_link+0xf4>
  ilock(dp);
80106439:	83 ec 0c             	sub    $0xc,%esp
8010643c:	50                   	push   %eax
8010643d:	e8 ee b3 ff ff       	call   80101830 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106442:	83 c4 10             	add    $0x10,%esp
80106445:	8b 03                	mov    (%ebx),%eax
80106447:	39 06                	cmp    %eax,(%esi)
80106449:	75 3d                	jne    80106488 <sys_link+0xe8>
8010644b:	83 ec 04             	sub    $0x4,%esp
8010644e:	ff 73 04             	pushl  0x4(%ebx)
80106451:	57                   	push   %edi
80106452:	56                   	push   %esi
80106453:	e8 08 bc ff ff       	call   80102060 <dirlink>
80106458:	83 c4 10             	add    $0x10,%esp
8010645b:	85 c0                	test   %eax,%eax
8010645d:	78 29                	js     80106488 <sys_link+0xe8>
  iunlockput(dp);
8010645f:	83 ec 0c             	sub    $0xc,%esp
80106462:	56                   	push   %esi
80106463:	e8 58 b6 ff ff       	call   80101ac0 <iunlockput>
  iput(ip);
80106468:	89 1c 24             	mov    %ebx,(%esp)
8010646b:	e8 f0 b4 ff ff       	call   80101960 <iput>
  end_op();
80106470:	e8 3b cb ff ff       	call   80102fb0 <end_op>
  return 0;
80106475:	83 c4 10             	add    $0x10,%esp
80106478:	31 c0                	xor    %eax,%eax
}
8010647a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010647d:	5b                   	pop    %ebx
8010647e:	5e                   	pop    %esi
8010647f:	5f                   	pop    %edi
80106480:	5d                   	pop    %ebp
80106481:	c3                   	ret    
80106482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80106488:	83 ec 0c             	sub    $0xc,%esp
8010648b:	56                   	push   %esi
8010648c:	e8 2f b6 ff ff       	call   80101ac0 <iunlockput>
    goto bad;
80106491:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80106494:	83 ec 0c             	sub    $0xc,%esp
80106497:	53                   	push   %ebx
80106498:	e8 93 b3 ff ff       	call   80101830 <ilock>
  ip->nlink--;
8010649d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801064a2:	89 1c 24             	mov    %ebx,(%esp)
801064a5:	e8 d6 b2 ff ff       	call   80101780 <iupdate>
  iunlockput(ip);
801064aa:	89 1c 24             	mov    %ebx,(%esp)
801064ad:	e8 0e b6 ff ff       	call   80101ac0 <iunlockput>
  end_op();
801064b2:	e8 f9 ca ff ff       	call   80102fb0 <end_op>
  return -1;
801064b7:	83 c4 10             	add    $0x10,%esp
}
801064ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801064bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064c2:	5b                   	pop    %ebx
801064c3:	5e                   	pop    %esi
801064c4:	5f                   	pop    %edi
801064c5:	5d                   	pop    %ebp
801064c6:	c3                   	ret    
    iunlockput(ip);
801064c7:	83 ec 0c             	sub    $0xc,%esp
801064ca:	53                   	push   %ebx
801064cb:	e8 f0 b5 ff ff       	call   80101ac0 <iunlockput>
    end_op();
801064d0:	e8 db ca ff ff       	call   80102fb0 <end_op>
    return -1;
801064d5:	83 c4 10             	add    $0x10,%esp
801064d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064dd:	eb 9b                	jmp    8010647a <sys_link+0xda>
    end_op();
801064df:	e8 cc ca ff ff       	call   80102fb0 <end_op>
    return -1;
801064e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064e9:	eb 8f                	jmp    8010647a <sys_link+0xda>
801064eb:	90                   	nop
801064ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801064f0 <sys_unlink>:
{
801064f0:	55                   	push   %ebp
801064f1:	89 e5                	mov    %esp,%ebp
801064f3:	57                   	push   %edi
801064f4:	56                   	push   %esi
801064f5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801064f6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801064f9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801064fc:	50                   	push   %eax
801064fd:	6a 00                	push   $0x0
801064ff:	e8 1c fa ff ff       	call   80105f20 <argstr>
80106504:	83 c4 10             	add    $0x10,%esp
80106507:	85 c0                	test   %eax,%eax
80106509:	0f 88 77 01 00 00    	js     80106686 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010650f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80106512:	e8 29 ca ff ff       	call   80102f40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106517:	83 ec 08             	sub    $0x8,%esp
8010651a:	53                   	push   %ebx
8010651b:	ff 75 c0             	pushl  -0x40(%ebp)
8010651e:	e8 1d bc ff ff       	call   80102140 <nameiparent>
80106523:	83 c4 10             	add    $0x10,%esp
80106526:	85 c0                	test   %eax,%eax
80106528:	89 c6                	mov    %eax,%esi
8010652a:	0f 84 60 01 00 00    	je     80106690 <sys_unlink+0x1a0>
  ilock(dp);
80106530:	83 ec 0c             	sub    $0xc,%esp
80106533:	50                   	push   %eax
80106534:	e8 f7 b2 ff ff       	call   80101830 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106539:	58                   	pop    %eax
8010653a:	5a                   	pop    %edx
8010653b:	68 89 8c 10 80       	push   $0x80108c89
80106540:	53                   	push   %ebx
80106541:	e8 fa b7 ff ff       	call   80101d40 <namecmp>
80106546:	83 c4 10             	add    $0x10,%esp
80106549:	85 c0                	test   %eax,%eax
8010654b:	0f 84 03 01 00 00    	je     80106654 <sys_unlink+0x164>
80106551:	83 ec 08             	sub    $0x8,%esp
80106554:	68 88 8c 10 80       	push   $0x80108c88
80106559:	53                   	push   %ebx
8010655a:	e8 e1 b7 ff ff       	call   80101d40 <namecmp>
8010655f:	83 c4 10             	add    $0x10,%esp
80106562:	85 c0                	test   %eax,%eax
80106564:	0f 84 ea 00 00 00    	je     80106654 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010656a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010656d:	83 ec 04             	sub    $0x4,%esp
80106570:	50                   	push   %eax
80106571:	53                   	push   %ebx
80106572:	56                   	push   %esi
80106573:	e8 e8 b7 ff ff       	call   80101d60 <dirlookup>
80106578:	83 c4 10             	add    $0x10,%esp
8010657b:	85 c0                	test   %eax,%eax
8010657d:	89 c3                	mov    %eax,%ebx
8010657f:	0f 84 cf 00 00 00    	je     80106654 <sys_unlink+0x164>
  ilock(ip);
80106585:	83 ec 0c             	sub    $0xc,%esp
80106588:	50                   	push   %eax
80106589:	e8 a2 b2 ff ff       	call   80101830 <ilock>
  if(ip->nlink < 1)
8010658e:	83 c4 10             	add    $0x10,%esp
80106591:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80106596:	0f 8e 10 01 00 00    	jle    801066ac <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010659c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801065a1:	74 6d                	je     80106610 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801065a3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801065a6:	83 ec 04             	sub    $0x4,%esp
801065a9:	6a 10                	push   $0x10
801065ab:	6a 00                	push   $0x0
801065ad:	50                   	push   %eax
801065ae:	e8 bd f5 ff ff       	call   80105b70 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801065b3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801065b6:	6a 10                	push   $0x10
801065b8:	ff 75 c4             	pushl  -0x3c(%ebp)
801065bb:	50                   	push   %eax
801065bc:	56                   	push   %esi
801065bd:	e8 4e b6 ff ff       	call   80101c10 <writei>
801065c2:	83 c4 20             	add    $0x20,%esp
801065c5:	83 f8 10             	cmp    $0x10,%eax
801065c8:	0f 85 eb 00 00 00    	jne    801066b9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801065ce:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801065d3:	0f 84 97 00 00 00    	je     80106670 <sys_unlink+0x180>
  iunlockput(dp);
801065d9:	83 ec 0c             	sub    $0xc,%esp
801065dc:	56                   	push   %esi
801065dd:	e8 de b4 ff ff       	call   80101ac0 <iunlockput>
  ip->nlink--;
801065e2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801065e7:	89 1c 24             	mov    %ebx,(%esp)
801065ea:	e8 91 b1 ff ff       	call   80101780 <iupdate>
  iunlockput(ip);
801065ef:	89 1c 24             	mov    %ebx,(%esp)
801065f2:	e8 c9 b4 ff ff       	call   80101ac0 <iunlockput>
  end_op();
801065f7:	e8 b4 c9 ff ff       	call   80102fb0 <end_op>
  return 0;
801065fc:	83 c4 10             	add    $0x10,%esp
801065ff:	31 c0                	xor    %eax,%eax
}
80106601:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106604:	5b                   	pop    %ebx
80106605:	5e                   	pop    %esi
80106606:	5f                   	pop    %edi
80106607:	5d                   	pop    %ebp
80106608:	c3                   	ret    
80106609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106610:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106614:	76 8d                	jbe    801065a3 <sys_unlink+0xb3>
80106616:	bf 20 00 00 00       	mov    $0x20,%edi
8010661b:	eb 0f                	jmp    8010662c <sys_unlink+0x13c>
8010661d:	8d 76 00             	lea    0x0(%esi),%esi
80106620:	83 c7 10             	add    $0x10,%edi
80106623:	3b 7b 58             	cmp    0x58(%ebx),%edi
80106626:	0f 83 77 ff ff ff    	jae    801065a3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010662c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010662f:	6a 10                	push   $0x10
80106631:	57                   	push   %edi
80106632:	50                   	push   %eax
80106633:	53                   	push   %ebx
80106634:	e8 d7 b4 ff ff       	call   80101b10 <readi>
80106639:	83 c4 10             	add    $0x10,%esp
8010663c:	83 f8 10             	cmp    $0x10,%eax
8010663f:	75 5e                	jne    8010669f <sys_unlink+0x1af>
    if(de.inum != 0)
80106641:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80106646:	74 d8                	je     80106620 <sys_unlink+0x130>
    iunlockput(ip);
80106648:	83 ec 0c             	sub    $0xc,%esp
8010664b:	53                   	push   %ebx
8010664c:	e8 6f b4 ff ff       	call   80101ac0 <iunlockput>
    goto bad;
80106651:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80106654:	83 ec 0c             	sub    $0xc,%esp
80106657:	56                   	push   %esi
80106658:	e8 63 b4 ff ff       	call   80101ac0 <iunlockput>
  end_op();
8010665d:	e8 4e c9 ff ff       	call   80102fb0 <end_op>
  return -1;
80106662:	83 c4 10             	add    $0x10,%esp
80106665:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010666a:	eb 95                	jmp    80106601 <sys_unlink+0x111>
8010666c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80106670:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80106675:	83 ec 0c             	sub    $0xc,%esp
80106678:	56                   	push   %esi
80106679:	e8 02 b1 ff ff       	call   80101780 <iupdate>
8010667e:	83 c4 10             	add    $0x10,%esp
80106681:	e9 53 ff ff ff       	jmp    801065d9 <sys_unlink+0xe9>
    return -1;
80106686:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010668b:	e9 71 ff ff ff       	jmp    80106601 <sys_unlink+0x111>
    end_op();
80106690:	e8 1b c9 ff ff       	call   80102fb0 <end_op>
    return -1;
80106695:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010669a:	e9 62 ff ff ff       	jmp    80106601 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010669f:	83 ec 0c             	sub    $0xc,%esp
801066a2:	68 d5 8f 10 80       	push   $0x80108fd5
801066a7:	e8 e4 9c ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801066ac:	83 ec 0c             	sub    $0xc,%esp
801066af:	68 c3 8f 10 80       	push   $0x80108fc3
801066b4:	e8 d7 9c ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801066b9:	83 ec 0c             	sub    $0xc,%esp
801066bc:	68 e7 8f 10 80       	push   $0x80108fe7
801066c1:	e8 ca 9c ff ff       	call   80100390 <panic>
801066c6:	8d 76 00             	lea    0x0(%esi),%esi
801066c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066d0 <sys_open>:

int
sys_open(void)
{
801066d0:	55                   	push   %ebp
801066d1:	89 e5                	mov    %esp,%ebp
801066d3:	57                   	push   %edi
801066d4:	56                   	push   %esi
801066d5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801066d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801066d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801066dc:	50                   	push   %eax
801066dd:	6a 00                	push   $0x0
801066df:	e8 3c f8 ff ff       	call   80105f20 <argstr>
801066e4:	83 c4 10             	add    $0x10,%esp
801066e7:	85 c0                	test   %eax,%eax
801066e9:	0f 88 1d 01 00 00    	js     8010680c <sys_open+0x13c>
801066ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801066f2:	83 ec 08             	sub    $0x8,%esp
801066f5:	50                   	push   %eax
801066f6:	6a 01                	push   $0x1
801066f8:	e8 73 f7 ff ff       	call   80105e70 <argint>
801066fd:	83 c4 10             	add    $0x10,%esp
80106700:	85 c0                	test   %eax,%eax
80106702:	0f 88 04 01 00 00    	js     8010680c <sys_open+0x13c>
    return -1;

  begin_op();
80106708:	e8 33 c8 ff ff       	call   80102f40 <begin_op>

  if(omode & O_CREATE){
8010670d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106711:	0f 85 a9 00 00 00    	jne    801067c0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106717:	83 ec 0c             	sub    $0xc,%esp
8010671a:	ff 75 e0             	pushl  -0x20(%ebp)
8010671d:	e8 fe b9 ff ff       	call   80102120 <namei>
80106722:	83 c4 10             	add    $0x10,%esp
80106725:	85 c0                	test   %eax,%eax
80106727:	89 c6                	mov    %eax,%esi
80106729:	0f 84 b2 00 00 00    	je     801067e1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010672f:	83 ec 0c             	sub    $0xc,%esp
80106732:	50                   	push   %eax
80106733:	e8 f8 b0 ff ff       	call   80101830 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106738:	83 c4 10             	add    $0x10,%esp
8010673b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106740:	0f 84 aa 00 00 00    	je     801067f0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106746:	e8 35 a6 ff ff       	call   80100d80 <filealloc>
8010674b:	85 c0                	test   %eax,%eax
8010674d:	89 c7                	mov    %eax,%edi
8010674f:	0f 84 a6 00 00 00    	je     801067fb <sys_open+0x12b>
  struct proc *curproc = myproc();
80106755:	e8 36 d4 ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010675a:	31 db                	xor    %ebx,%ebx
8010675c:	eb 0e                	jmp    8010676c <sys_open+0x9c>
8010675e:	66 90                	xchg   %ax,%ax
80106760:	83 c3 01             	add    $0x1,%ebx
80106763:	83 fb 10             	cmp    $0x10,%ebx
80106766:	0f 84 ac 00 00 00    	je     80106818 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010676c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106770:	85 d2                	test   %edx,%edx
80106772:	75 ec                	jne    80106760 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106774:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106777:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010677b:	56                   	push   %esi
8010677c:	e8 8f b1 ff ff       	call   80101910 <iunlock>
  end_op();
80106781:	e8 2a c8 ff ff       	call   80102fb0 <end_op>

  f->type = FD_INODE;
80106786:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010678c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->ip = ip;
8010678f:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80106792:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106799:	89 d0                	mov    %edx,%eax
8010679b:	f7 d0                	not    %eax
8010679d:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801067a0:	83 e2 03             	and    $0x3,%edx
801067a3:	0f 95 47 09          	setne  0x9(%edi)
  f->readable = !(omode & O_WRONLY);
801067a7:	88 47 08             	mov    %al,0x8(%edi)
  procfs_add_inode(ip);
801067aa:	89 34 24             	mov    %esi,(%esp)
801067ad:	e8 4e e1 ff ff       	call   80104900 <procfs_add_inode>
  return fd;
801067b2:	83 c4 10             	add    $0x10,%esp
}
801067b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067b8:	89 d8                	mov    %ebx,%eax
801067ba:	5b                   	pop    %ebx
801067bb:	5e                   	pop    %esi
801067bc:	5f                   	pop    %edi
801067bd:	5d                   	pop    %ebp
801067be:	c3                   	ret    
801067bf:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
801067c0:	83 ec 0c             	sub    $0xc,%esp
801067c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801067c6:	31 c9                	xor    %ecx,%ecx
801067c8:	6a 00                	push   $0x0
801067ca:	ba 02 00 00 00       	mov    $0x2,%edx
801067cf:	e8 ec f7 ff ff       	call   80105fc0 <create>
    if(ip == 0){
801067d4:	83 c4 10             	add    $0x10,%esp
801067d7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801067d9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801067db:	0f 85 65 ff ff ff    	jne    80106746 <sys_open+0x76>
      end_op();
801067e1:	e8 ca c7 ff ff       	call   80102fb0 <end_op>
      return -1;
801067e6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801067eb:	eb c8                	jmp    801067b5 <sys_open+0xe5>
801067ed:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801067f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801067f3:	85 c9                	test   %ecx,%ecx
801067f5:	0f 84 4b ff ff ff    	je     80106746 <sys_open+0x76>
    iunlockput(ip);
801067fb:	83 ec 0c             	sub    $0xc,%esp
801067fe:	56                   	push   %esi
801067ff:	e8 bc b2 ff ff       	call   80101ac0 <iunlockput>
    end_op();
80106804:	e8 a7 c7 ff ff       	call   80102fb0 <end_op>
    return -1;
80106809:	83 c4 10             	add    $0x10,%esp
8010680c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106811:	eb a2                	jmp    801067b5 <sys_open+0xe5>
80106813:	90                   	nop
80106814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80106818:	83 ec 0c             	sub    $0xc,%esp
8010681b:	57                   	push   %edi
8010681c:	e8 1f a6 ff ff       	call   80100e40 <fileclose>
80106821:	83 c4 10             	add    $0x10,%esp
80106824:	eb d5                	jmp    801067fb <sys_open+0x12b>
80106826:	8d 76 00             	lea    0x0(%esi),%esi
80106829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106830 <sys_mkdir>:

int
sys_mkdir(void)
{
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106836:	e8 05 c7 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010683b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010683e:	83 ec 08             	sub    $0x8,%esp
80106841:	50                   	push   %eax
80106842:	6a 00                	push   $0x0
80106844:	e8 d7 f6 ff ff       	call   80105f20 <argstr>
80106849:	83 c4 10             	add    $0x10,%esp
8010684c:	85 c0                	test   %eax,%eax
8010684e:	78 30                	js     80106880 <sys_mkdir+0x50>
80106850:	83 ec 0c             	sub    $0xc,%esp
80106853:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106856:	31 c9                	xor    %ecx,%ecx
80106858:	6a 00                	push   $0x0
8010685a:	ba 01 00 00 00       	mov    $0x1,%edx
8010685f:	e8 5c f7 ff ff       	call   80105fc0 <create>
80106864:	83 c4 10             	add    $0x10,%esp
80106867:	85 c0                	test   %eax,%eax
80106869:	74 15                	je     80106880 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010686b:	83 ec 0c             	sub    $0xc,%esp
8010686e:	50                   	push   %eax
8010686f:	e8 4c b2 ff ff       	call   80101ac0 <iunlockput>
  end_op();
80106874:	e8 37 c7 ff ff       	call   80102fb0 <end_op>
  return 0;
80106879:	83 c4 10             	add    $0x10,%esp
8010687c:	31 c0                	xor    %eax,%eax
}
8010687e:	c9                   	leave  
8010687f:	c3                   	ret    
    end_op();
80106880:	e8 2b c7 ff ff       	call   80102fb0 <end_op>
    return -1;
80106885:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010688a:	c9                   	leave  
8010688b:	c3                   	ret    
8010688c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106890 <sys_mknod>:

int
sys_mknod(void)
{
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106896:	e8 a5 c6 ff ff       	call   80102f40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010689b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010689e:	83 ec 08             	sub    $0x8,%esp
801068a1:	50                   	push   %eax
801068a2:	6a 00                	push   $0x0
801068a4:	e8 77 f6 ff ff       	call   80105f20 <argstr>
801068a9:	83 c4 10             	add    $0x10,%esp
801068ac:	85 c0                	test   %eax,%eax
801068ae:	78 60                	js     80106910 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801068b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068b3:	83 ec 08             	sub    $0x8,%esp
801068b6:	50                   	push   %eax
801068b7:	6a 01                	push   $0x1
801068b9:	e8 b2 f5 ff ff       	call   80105e70 <argint>
  if((argstr(0, &path)) < 0 ||
801068be:	83 c4 10             	add    $0x10,%esp
801068c1:	85 c0                	test   %eax,%eax
801068c3:	78 4b                	js     80106910 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801068c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068c8:	83 ec 08             	sub    $0x8,%esp
801068cb:	50                   	push   %eax
801068cc:	6a 02                	push   $0x2
801068ce:	e8 9d f5 ff ff       	call   80105e70 <argint>
     argint(1, &major) < 0 ||
801068d3:	83 c4 10             	add    $0x10,%esp
801068d6:	85 c0                	test   %eax,%eax
801068d8:	78 36                	js     80106910 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801068da:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801068de:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801068e1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801068e5:	ba 03 00 00 00       	mov    $0x3,%edx
801068ea:	50                   	push   %eax
801068eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801068ee:	e8 cd f6 ff ff       	call   80105fc0 <create>
801068f3:	83 c4 10             	add    $0x10,%esp
801068f6:	85 c0                	test   %eax,%eax
801068f8:	74 16                	je     80106910 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801068fa:	83 ec 0c             	sub    $0xc,%esp
801068fd:	50                   	push   %eax
801068fe:	e8 bd b1 ff ff       	call   80101ac0 <iunlockput>
  end_op();
80106903:	e8 a8 c6 ff ff       	call   80102fb0 <end_op>
  return 0;
80106908:	83 c4 10             	add    $0x10,%esp
8010690b:	31 c0                	xor    %eax,%eax
}
8010690d:	c9                   	leave  
8010690e:	c3                   	ret    
8010690f:	90                   	nop
    end_op();
80106910:	e8 9b c6 ff ff       	call   80102fb0 <end_op>
    return -1;
80106915:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010691a:	c9                   	leave  
8010691b:	c3                   	ret    
8010691c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106920 <sys_chdir>:

int
sys_chdir(void)
{
80106920:	55                   	push   %ebp
80106921:	89 e5                	mov    %esp,%ebp
80106923:	56                   	push   %esi
80106924:	53                   	push   %ebx
80106925:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106928:	e8 63 d2 ff ff       	call   80103b90 <myproc>
8010692d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010692f:	e8 0c c6 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106934:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106937:	83 ec 08             	sub    $0x8,%esp
8010693a:	50                   	push   %eax
8010693b:	6a 00                	push   $0x0
8010693d:	e8 de f5 ff ff       	call   80105f20 <argstr>
80106942:	83 c4 10             	add    $0x10,%esp
80106945:	85 c0                	test   %eax,%eax
80106947:	0f 88 93 00 00 00    	js     801069e0 <sys_chdir+0xc0>
8010694d:	83 ec 0c             	sub    $0xc,%esp
80106950:	ff 75 f4             	pushl  -0xc(%ebp)
80106953:	e8 c8 b7 ff ff       	call   80102120 <namei>
80106958:	83 c4 10             	add    $0x10,%esp
8010695b:	85 c0                	test   %eax,%eax
8010695d:	89 c3                	mov    %eax,%ebx
8010695f:	74 7f                	je     801069e0 <sys_chdir+0xc0>
    end_op();
    return -1;
  }
  ilock(ip);
80106961:	83 ec 0c             	sub    $0xc,%esp
80106964:	50                   	push   %eax
80106965:	e8 c6 ae ff ff       	call   80101830 <ilock>
  if(ip->type != T_DIR && !(IS_DEV_DIR(ip))){
8010696a:	0f b7 43 50          	movzwl 0x50(%ebx),%eax
8010696e:	83 c4 10             	add    $0x10,%esp
80106971:	66 83 f8 01          	cmp    $0x1,%ax
80106975:	74 24                	je     8010699b <sys_chdir+0x7b>
80106977:	66 83 f8 03          	cmp    $0x3,%ax
8010697b:	75 4b                	jne    801069c8 <sys_chdir+0xa8>
8010697d:	0f bf 43 52          	movswl 0x52(%ebx),%eax
80106981:	c1 e0 04             	shl    $0x4,%eax
80106984:	8b 80 80 2e 11 80    	mov    -0x7feed180(%eax),%eax
8010698a:	85 c0                	test   %eax,%eax
8010698c:	74 3a                	je     801069c8 <sys_chdir+0xa8>
8010698e:	83 ec 0c             	sub    $0xc,%esp
80106991:	53                   	push   %ebx
80106992:	ff d0                	call   *%eax
80106994:	83 c4 10             	add    $0x10,%esp
80106997:	85 c0                	test   %eax,%eax
80106999:	74 2d                	je     801069c8 <sys_chdir+0xa8>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010699b:	83 ec 0c             	sub    $0xc,%esp
8010699e:	53                   	push   %ebx
8010699f:	e8 6c af ff ff       	call   80101910 <iunlock>
  iput(curproc->cwd);
801069a4:	58                   	pop    %eax
801069a5:	ff 76 68             	pushl  0x68(%esi)
801069a8:	e8 b3 af ff ff       	call   80101960 <iput>
  end_op();
801069ad:	e8 fe c5 ff ff       	call   80102fb0 <end_op>
  curproc->cwd = ip;
801069b2:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801069b5:	83 c4 10             	add    $0x10,%esp
801069b8:	31 c0                	xor    %eax,%eax
}
801069ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
801069bd:	5b                   	pop    %ebx
801069be:	5e                   	pop    %esi
801069bf:	5d                   	pop    %ebp
801069c0:	c3                   	ret    
801069c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
801069c8:	83 ec 0c             	sub    $0xc,%esp
801069cb:	53                   	push   %ebx
801069cc:	e8 ef b0 ff ff       	call   80101ac0 <iunlockput>
    end_op();
801069d1:	e8 da c5 ff ff       	call   80102fb0 <end_op>
    return -1;
801069d6:	83 c4 10             	add    $0x10,%esp
801069d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069de:	eb da                	jmp    801069ba <sys_chdir+0x9a>
    end_op();
801069e0:	e8 cb c5 ff ff       	call   80102fb0 <end_op>
    return -1;
801069e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069ea:	eb ce                	jmp    801069ba <sys_chdir+0x9a>
801069ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801069f0 <sys_exec>:

int
sys_exec(void)
{
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	57                   	push   %edi
801069f4:	56                   	push   %esi
801069f5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801069f6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801069fc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106a02:	50                   	push   %eax
80106a03:	6a 00                	push   $0x0
80106a05:	e8 16 f5 ff ff       	call   80105f20 <argstr>
80106a0a:	83 c4 10             	add    $0x10,%esp
80106a0d:	85 c0                	test   %eax,%eax
80106a0f:	0f 88 87 00 00 00    	js     80106a9c <sys_exec+0xac>
80106a15:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106a1b:	83 ec 08             	sub    $0x8,%esp
80106a1e:	50                   	push   %eax
80106a1f:	6a 01                	push   $0x1
80106a21:	e8 4a f4 ff ff       	call   80105e70 <argint>
80106a26:	83 c4 10             	add    $0x10,%esp
80106a29:	85 c0                	test   %eax,%eax
80106a2b:	78 6f                	js     80106a9c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106a2d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106a33:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80106a36:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106a38:	68 80 00 00 00       	push   $0x80
80106a3d:	6a 00                	push   $0x0
80106a3f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106a45:	50                   	push   %eax
80106a46:	e8 25 f1 ff ff       	call   80105b70 <memset>
80106a4b:	83 c4 10             	add    $0x10,%esp
80106a4e:	eb 2c                	jmp    80106a7c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80106a50:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106a56:	85 c0                	test   %eax,%eax
80106a58:	74 56                	je     80106ab0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106a5a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106a60:	83 ec 08             	sub    $0x8,%esp
80106a63:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80106a66:	52                   	push   %edx
80106a67:	50                   	push   %eax
80106a68:	e8 93 f3 ff ff       	call   80105e00 <fetchstr>
80106a6d:	83 c4 10             	add    $0x10,%esp
80106a70:	85 c0                	test   %eax,%eax
80106a72:	78 28                	js     80106a9c <sys_exec+0xac>
  for(i=0;; i++){
80106a74:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106a77:	83 fb 20             	cmp    $0x20,%ebx
80106a7a:	74 20                	je     80106a9c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106a7c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106a82:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106a89:	83 ec 08             	sub    $0x8,%esp
80106a8c:	57                   	push   %edi
80106a8d:	01 f0                	add    %esi,%eax
80106a8f:	50                   	push   %eax
80106a90:	e8 2b f3 ff ff       	call   80105dc0 <fetchint>
80106a95:	83 c4 10             	add    $0x10,%esp
80106a98:	85 c0                	test   %eax,%eax
80106a9a:	79 b4                	jns    80106a50 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80106a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106a9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106aa4:	5b                   	pop    %ebx
80106aa5:	5e                   	pop    %esi
80106aa6:	5f                   	pop    %edi
80106aa7:	5d                   	pop    %ebp
80106aa8:	c3                   	ret    
80106aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106ab0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106ab6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106ab9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106ac0:	00 00 00 00 
  return exec(path, argv);
80106ac4:	50                   	push   %eax
80106ac5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80106acb:	e8 40 9f ff ff       	call   80100a10 <exec>
80106ad0:	83 c4 10             	add    $0x10,%esp
}
80106ad3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ad6:	5b                   	pop    %ebx
80106ad7:	5e                   	pop    %esi
80106ad8:	5f                   	pop    %edi
80106ad9:	5d                   	pop    %ebp
80106ada:	c3                   	ret    
80106adb:	90                   	nop
80106adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ae0 <sys_pipe>:

int
sys_pipe(void)
{
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	57                   	push   %edi
80106ae4:	56                   	push   %esi
80106ae5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106ae6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106ae9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106aec:	6a 08                	push   $0x8
80106aee:	50                   	push   %eax
80106aef:	6a 00                	push   $0x0
80106af1:	e8 ca f3 ff ff       	call   80105ec0 <argptr>
80106af6:	83 c4 10             	add    $0x10,%esp
80106af9:	85 c0                	test   %eax,%eax
80106afb:	0f 88 ae 00 00 00    	js     80106baf <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106b01:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106b04:	83 ec 08             	sub    $0x8,%esp
80106b07:	50                   	push   %eax
80106b08:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106b0b:	50                   	push   %eax
80106b0c:	e8 cf ca ff ff       	call   801035e0 <pipealloc>
80106b11:	83 c4 10             	add    $0x10,%esp
80106b14:	85 c0                	test   %eax,%eax
80106b16:	0f 88 93 00 00 00    	js     80106baf <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106b1c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106b1f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106b21:	e8 6a d0 ff ff       	call   80103b90 <myproc>
80106b26:	eb 10                	jmp    80106b38 <sys_pipe+0x58>
80106b28:	90                   	nop
80106b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106b30:	83 c3 01             	add    $0x1,%ebx
80106b33:	83 fb 10             	cmp    $0x10,%ebx
80106b36:	74 60                	je     80106b98 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80106b38:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106b3c:	85 f6                	test   %esi,%esi
80106b3e:	75 f0                	jne    80106b30 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80106b40:	8d 73 08             	lea    0x8(%ebx),%esi
80106b43:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106b47:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80106b4a:	e8 41 d0 ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106b4f:	31 d2                	xor    %edx,%edx
80106b51:	eb 0d                	jmp    80106b60 <sys_pipe+0x80>
80106b53:	90                   	nop
80106b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b58:	83 c2 01             	add    $0x1,%edx
80106b5b:	83 fa 10             	cmp    $0x10,%edx
80106b5e:	74 28                	je     80106b88 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80106b60:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106b64:	85 c9                	test   %ecx,%ecx
80106b66:	75 f0                	jne    80106b58 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80106b68:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80106b6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106b6f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106b71:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106b74:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106b77:	31 c0                	xor    %eax,%eax
}
80106b79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b7c:	5b                   	pop    %ebx
80106b7d:	5e                   	pop    %esi
80106b7e:	5f                   	pop    %edi
80106b7f:	5d                   	pop    %ebp
80106b80:	c3                   	ret    
80106b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106b88:	e8 03 d0 ff ff       	call   80103b90 <myproc>
80106b8d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106b94:	00 
80106b95:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106b98:	83 ec 0c             	sub    $0xc,%esp
80106b9b:	ff 75 e0             	pushl  -0x20(%ebp)
80106b9e:	e8 9d a2 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80106ba3:	58                   	pop    %eax
80106ba4:	ff 75 e4             	pushl  -0x1c(%ebp)
80106ba7:	e8 94 a2 ff ff       	call   80100e40 <fileclose>
    return -1;
80106bac:	83 c4 10             	add    $0x10,%esp
80106baf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bb4:	eb c3                	jmp    80106b79 <sys_pipe+0x99>
80106bb6:	66 90                	xchg   %ax,%ax
80106bb8:	66 90                	xchg   %ax,%ax
80106bba:	66 90                	xchg   %ax,%ax
80106bbc:	66 90                	xchg   %ax,%ax
80106bbe:	66 90                	xchg   %ax,%ax

80106bc0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106bc3:	5d                   	pop    %ebp
  return fork();
80106bc4:	e9 67 d1 ff ff       	jmp    80103d30 <fork>
80106bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106bd0 <sys_exit>:

int
sys_exit(void)
{
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	83 ec 08             	sub    $0x8,%esp
  exit();
80106bd6:	e8 d5 d3 ff ff       	call   80103fb0 <exit>
  return 0;  // not reached
}
80106bdb:	31 c0                	xor    %eax,%eax
80106bdd:	c9                   	leave  
80106bde:	c3                   	ret    
80106bdf:	90                   	nop

80106be0 <sys_wait>:

int
sys_wait(void)
{
80106be0:	55                   	push   %ebp
80106be1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80106be3:	5d                   	pop    %ebp
  return wait();
80106be4:	e9 07 d6 ff ff       	jmp    801041f0 <wait>
80106be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106bf0 <sys_kill>:

int
sys_kill(void)
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106bf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bf9:	50                   	push   %eax
80106bfa:	6a 00                	push   $0x0
80106bfc:	e8 6f f2 ff ff       	call   80105e70 <argint>
80106c01:	83 c4 10             	add    $0x10,%esp
80106c04:	85 c0                	test   %eax,%eax
80106c06:	78 18                	js     80106c20 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106c08:	83 ec 0c             	sub    $0xc,%esp
80106c0b:	ff 75 f4             	pushl  -0xc(%ebp)
80106c0e:	e8 2d d7 ff ff       	call   80104340 <kill>
80106c13:	83 c4 10             	add    $0x10,%esp
}
80106c16:	c9                   	leave  
80106c17:	c3                   	ret    
80106c18:	90                   	nop
80106c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c25:	c9                   	leave  
80106c26:	c3                   	ret    
80106c27:	89 f6                	mov    %esi,%esi
80106c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c30 <sys_getpid>:

int
sys_getpid(void)
{
80106c30:	55                   	push   %ebp
80106c31:	89 e5                	mov    %esp,%ebp
80106c33:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106c36:	e8 55 cf ff ff       	call   80103b90 <myproc>
80106c3b:	8b 40 10             	mov    0x10(%eax),%eax
}
80106c3e:	c9                   	leave  
80106c3f:	c3                   	ret    

80106c40 <sys_sbrk>:

int
sys_sbrk(void)
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106c44:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106c47:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80106c4a:	50                   	push   %eax
80106c4b:	6a 00                	push   $0x0
80106c4d:	e8 1e f2 ff ff       	call   80105e70 <argint>
80106c52:	83 c4 10             	add    $0x10,%esp
80106c55:	85 c0                	test   %eax,%eax
80106c57:	78 27                	js     80106c80 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106c59:	e8 32 cf ff ff       	call   80103b90 <myproc>
  if(growproc(n) < 0)
80106c5e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106c61:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106c63:	ff 75 f4             	pushl  -0xc(%ebp)
80106c66:	e8 45 d0 ff ff       	call   80103cb0 <growproc>
80106c6b:	83 c4 10             	add    $0x10,%esp
80106c6e:	85 c0                	test   %eax,%eax
80106c70:	78 0e                	js     80106c80 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106c72:	89 d8                	mov    %ebx,%eax
80106c74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106c77:	c9                   	leave  
80106c78:	c3                   	ret    
80106c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106c80:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106c85:	eb eb                	jmp    80106c72 <sys_sbrk+0x32>
80106c87:	89 f6                	mov    %esi,%esi
80106c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c90 <sys_sleep>:

int
sys_sleep(void)
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106c94:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106c97:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80106c9a:	50                   	push   %eax
80106c9b:	6a 00                	push   $0x0
80106c9d:	e8 ce f1 ff ff       	call   80105e70 <argint>
80106ca2:	83 c4 10             	add    $0x10,%esp
80106ca5:	85 c0                	test   %eax,%eax
80106ca7:	0f 88 8a 00 00 00    	js     80106d37 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106cad:	83 ec 0c             	sub    $0xc,%esp
80106cb0:	68 00 7d 11 80       	push   $0x80117d00
80106cb5:	e8 a6 ed ff ff       	call   80105a60 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106cba:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106cbd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106cc0:	8b 1d 40 85 11 80    	mov    0x80118540,%ebx
  while(ticks - ticks0 < n){
80106cc6:	85 d2                	test   %edx,%edx
80106cc8:	75 27                	jne    80106cf1 <sys_sleep+0x61>
80106cca:	eb 54                	jmp    80106d20 <sys_sleep+0x90>
80106ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106cd0:	83 ec 08             	sub    $0x8,%esp
80106cd3:	68 00 7d 11 80       	push   $0x80117d00
80106cd8:	68 40 85 11 80       	push   $0x80118540
80106cdd:	e8 4e d4 ff ff       	call   80104130 <sleep>
  while(ticks - ticks0 < n){
80106ce2:	a1 40 85 11 80       	mov    0x80118540,%eax
80106ce7:	83 c4 10             	add    $0x10,%esp
80106cea:	29 d8                	sub    %ebx,%eax
80106cec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106cef:	73 2f                	jae    80106d20 <sys_sleep+0x90>
    if(myproc()->killed){
80106cf1:	e8 9a ce ff ff       	call   80103b90 <myproc>
80106cf6:	8b 40 24             	mov    0x24(%eax),%eax
80106cf9:	85 c0                	test   %eax,%eax
80106cfb:	74 d3                	je     80106cd0 <sys_sleep+0x40>
      release(&tickslock);
80106cfd:	83 ec 0c             	sub    $0xc,%esp
80106d00:	68 00 7d 11 80       	push   $0x80117d00
80106d05:	e8 16 ee ff ff       	call   80105b20 <release>
      return -1;
80106d0a:	83 c4 10             	add    $0x10,%esp
80106d0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106d12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106d15:	c9                   	leave  
80106d16:	c3                   	ret    
80106d17:	89 f6                	mov    %esi,%esi
80106d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106d20:	83 ec 0c             	sub    $0xc,%esp
80106d23:	68 00 7d 11 80       	push   $0x80117d00
80106d28:	e8 f3 ed ff ff       	call   80105b20 <release>
  return 0;
80106d2d:	83 c4 10             	add    $0x10,%esp
80106d30:	31 c0                	xor    %eax,%eax
}
80106d32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106d35:	c9                   	leave  
80106d36:	c3                   	ret    
    return -1;
80106d37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d3c:	eb f4                	jmp    80106d32 <sys_sleep+0xa2>
80106d3e:	66 90                	xchg   %ax,%ax

80106d40 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	53                   	push   %ebx
80106d44:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106d47:	68 00 7d 11 80       	push   $0x80117d00
80106d4c:	e8 0f ed ff ff       	call   80105a60 <acquire>
  xticks = ticks;
80106d51:	8b 1d 40 85 11 80    	mov    0x80118540,%ebx
  release(&tickslock);
80106d57:	c7 04 24 00 7d 11 80 	movl   $0x80117d00,(%esp)
80106d5e:	e8 bd ed ff ff       	call   80105b20 <release>
  return xticks;
}
80106d63:	89 d8                	mov    %ebx,%eax
80106d65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106d68:	c9                   	leave  
80106d69:	c3                   	ret    

80106d6a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106d6a:	1e                   	push   %ds
  pushl %es
80106d6b:	06                   	push   %es
  pushl %fs
80106d6c:	0f a0                	push   %fs
  pushl %gs
80106d6e:	0f a8                	push   %gs
  pushal
80106d70:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106d71:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106d75:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106d77:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106d79:	54                   	push   %esp
  call trap
80106d7a:	e8 c1 00 00 00       	call   80106e40 <trap>
  addl $4, %esp
80106d7f:	83 c4 04             	add    $0x4,%esp

80106d82 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106d82:	61                   	popa   
  popl %gs
80106d83:	0f a9                	pop    %gs
  popl %fs
80106d85:	0f a1                	pop    %fs
  popl %es
80106d87:	07                   	pop    %es
  popl %ds
80106d88:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106d89:	83 c4 08             	add    $0x8,%esp
  iret
80106d8c:	cf                   	iret   
80106d8d:	66 90                	xchg   %ax,%ax
80106d8f:	90                   	nop

80106d90 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106d90:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106d91:	31 c0                	xor    %eax,%eax
{
80106d93:	89 e5                	mov    %esp,%ebp
80106d95:	83 ec 08             	sub    $0x8,%esp
80106d98:	90                   	nop
80106d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106da0:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106da7:	c7 04 c5 42 7d 11 80 	movl   $0x8e000008,-0x7fee82be(,%eax,8)
80106dae:	08 00 00 8e 
80106db2:	66 89 14 c5 40 7d 11 	mov    %dx,-0x7fee82c0(,%eax,8)
80106db9:	80 
80106dba:	c1 ea 10             	shr    $0x10,%edx
80106dbd:	66 89 14 c5 46 7d 11 	mov    %dx,-0x7fee82ba(,%eax,8)
80106dc4:	80 
  for(i = 0; i < 256; i++)
80106dc5:	83 c0 01             	add    $0x1,%eax
80106dc8:	3d 00 01 00 00       	cmp    $0x100,%eax
80106dcd:	75 d1                	jne    80106da0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106dcf:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
80106dd4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106dd7:	c7 05 42 7f 11 80 08 	movl   $0xef000008,0x80117f42
80106dde:	00 00 ef 
  initlock(&tickslock, "time");
80106de1:	68 f6 8f 10 80       	push   $0x80108ff6
80106de6:	68 00 7d 11 80       	push   $0x80117d00
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106deb:	66 a3 40 7f 11 80    	mov    %ax,0x80117f40
80106df1:	c1 e8 10             	shr    $0x10,%eax
80106df4:	66 a3 46 7f 11 80    	mov    %ax,0x80117f46
  initlock(&tickslock, "time");
80106dfa:	e8 21 eb ff ff       	call   80105920 <initlock>
}
80106dff:	83 c4 10             	add    $0x10,%esp
80106e02:	c9                   	leave  
80106e03:	c3                   	ret    
80106e04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106e10 <idtinit>:

void
idtinit(void)
{
80106e10:	55                   	push   %ebp
  pd[0] = size-1;
80106e11:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106e16:	89 e5                	mov    %esp,%ebp
80106e18:	83 ec 10             	sub    $0x10,%esp
80106e1b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106e1f:	b8 40 7d 11 80       	mov    $0x80117d40,%eax
80106e24:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106e28:	c1 e8 10             	shr    $0x10,%eax
80106e2b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106e2f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106e32:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106e35:	c9                   	leave  
80106e36:	c3                   	ret    
80106e37:	89 f6                	mov    %esi,%esi
80106e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e40 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
80106e46:	83 ec 1c             	sub    $0x1c,%esp
80106e49:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80106e4c:	8b 47 30             	mov    0x30(%edi),%eax
80106e4f:	83 f8 40             	cmp    $0x40,%eax
80106e52:	0f 84 f0 00 00 00    	je     80106f48 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106e58:	83 e8 20             	sub    $0x20,%eax
80106e5b:	83 f8 1f             	cmp    $0x1f,%eax
80106e5e:	77 10                	ja     80106e70 <trap+0x30>
80106e60:	ff 24 85 9c 90 10 80 	jmp    *-0x7fef6f64(,%eax,4)
80106e67:	89 f6                	mov    %esi,%esi
80106e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106e70:	e8 1b cd ff ff       	call   80103b90 <myproc>
80106e75:	85 c0                	test   %eax,%eax
80106e77:	8b 5f 38             	mov    0x38(%edi),%ebx
80106e7a:	0f 84 14 02 00 00    	je     80107094 <trap+0x254>
80106e80:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106e84:	0f 84 0a 02 00 00    	je     80107094 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106e8a:	0f 20 d1             	mov    %cr2,%ecx
80106e8d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e90:	e8 db cc ff ff       	call   80103b70 <cpuid>
80106e95:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106e98:	8b 47 34             	mov    0x34(%edi),%eax
80106e9b:	8b 77 30             	mov    0x30(%edi),%esi
80106e9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106ea1:	e8 ea cc ff ff       	call   80103b90 <myproc>
80106ea6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ea9:	e8 e2 cc ff ff       	call   80103b90 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106eae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106eb1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106eb4:	51                   	push   %ecx
80106eb5:	53                   	push   %ebx
80106eb6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106eb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106eba:	ff 75 e4             	pushl  -0x1c(%ebp)
80106ebd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106ebe:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ec1:	52                   	push   %edx
80106ec2:	ff 70 10             	pushl  0x10(%eax)
80106ec5:	68 58 90 10 80       	push   $0x80109058
80106eca:	e8 91 97 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106ecf:	83 c4 20             	add    $0x20,%esp
80106ed2:	e8 b9 cc ff ff       	call   80103b90 <myproc>
80106ed7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ede:	e8 ad cc ff ff       	call   80103b90 <myproc>
80106ee3:	85 c0                	test   %eax,%eax
80106ee5:	74 1d                	je     80106f04 <trap+0xc4>
80106ee7:	e8 a4 cc ff ff       	call   80103b90 <myproc>
80106eec:	8b 50 24             	mov    0x24(%eax),%edx
80106eef:	85 d2                	test   %edx,%edx
80106ef1:	74 11                	je     80106f04 <trap+0xc4>
80106ef3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106ef7:	83 e0 03             	and    $0x3,%eax
80106efa:	66 83 f8 03          	cmp    $0x3,%ax
80106efe:	0f 84 4c 01 00 00    	je     80107050 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106f04:	e8 87 cc ff ff       	call   80103b90 <myproc>
80106f09:	85 c0                	test   %eax,%eax
80106f0b:	74 0b                	je     80106f18 <trap+0xd8>
80106f0d:	e8 7e cc ff ff       	call   80103b90 <myproc>
80106f12:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106f16:	74 68                	je     80106f80 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106f18:	e8 73 cc ff ff       	call   80103b90 <myproc>
80106f1d:	85 c0                	test   %eax,%eax
80106f1f:	74 19                	je     80106f3a <trap+0xfa>
80106f21:	e8 6a cc ff ff       	call   80103b90 <myproc>
80106f26:	8b 40 24             	mov    0x24(%eax),%eax
80106f29:	85 c0                	test   %eax,%eax
80106f2b:	74 0d                	je     80106f3a <trap+0xfa>
80106f2d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106f31:	83 e0 03             	and    $0x3,%eax
80106f34:	66 83 f8 03          	cmp    $0x3,%ax
80106f38:	74 37                	je     80106f71 <trap+0x131>
    exit();
}
80106f3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f3d:	5b                   	pop    %ebx
80106f3e:	5e                   	pop    %esi
80106f3f:	5f                   	pop    %edi
80106f40:	5d                   	pop    %ebp
80106f41:	c3                   	ret    
80106f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106f48:	e8 43 cc ff ff       	call   80103b90 <myproc>
80106f4d:	8b 58 24             	mov    0x24(%eax),%ebx
80106f50:	85 db                	test   %ebx,%ebx
80106f52:	0f 85 e8 00 00 00    	jne    80107040 <trap+0x200>
    myproc()->tf = tf;
80106f58:	e8 33 cc ff ff       	call   80103b90 <myproc>
80106f5d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106f60:	e8 fb ef ff ff       	call   80105f60 <syscall>
    if(myproc()->killed)
80106f65:	e8 26 cc ff ff       	call   80103b90 <myproc>
80106f6a:	8b 48 24             	mov    0x24(%eax),%ecx
80106f6d:	85 c9                	test   %ecx,%ecx
80106f6f:	74 c9                	je     80106f3a <trap+0xfa>
}
80106f71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f74:	5b                   	pop    %ebx
80106f75:	5e                   	pop    %esi
80106f76:	5f                   	pop    %edi
80106f77:	5d                   	pop    %ebp
      exit();
80106f78:	e9 33 d0 ff ff       	jmp    80103fb0 <exit>
80106f7d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106f80:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106f84:	75 92                	jne    80106f18 <trap+0xd8>
    yield();
80106f86:	e8 55 d1 ff ff       	call   801040e0 <yield>
80106f8b:	eb 8b                	jmp    80106f18 <trap+0xd8>
80106f8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106f90:	e8 db cb ff ff       	call   80103b70 <cpuid>
80106f95:	85 c0                	test   %eax,%eax
80106f97:	0f 84 c3 00 00 00    	je     80107060 <trap+0x220>
    lapiceoi();
80106f9d:	e8 4e bb ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106fa2:	e8 e9 cb ff ff       	call   80103b90 <myproc>
80106fa7:	85 c0                	test   %eax,%eax
80106fa9:	0f 85 38 ff ff ff    	jne    80106ee7 <trap+0xa7>
80106faf:	e9 50 ff ff ff       	jmp    80106f04 <trap+0xc4>
80106fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106fb8:	e8 f3 b9 ff ff       	call   801029b0 <kbdintr>
    lapiceoi();
80106fbd:	e8 2e bb ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106fc2:	e8 c9 cb ff ff       	call   80103b90 <myproc>
80106fc7:	85 c0                	test   %eax,%eax
80106fc9:	0f 85 18 ff ff ff    	jne    80106ee7 <trap+0xa7>
80106fcf:	e9 30 ff ff ff       	jmp    80106f04 <trap+0xc4>
80106fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106fd8:	e8 53 02 00 00       	call   80107230 <uartintr>
    lapiceoi();
80106fdd:	e8 0e bb ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106fe2:	e8 a9 cb ff ff       	call   80103b90 <myproc>
80106fe7:	85 c0                	test   %eax,%eax
80106fe9:	0f 85 f8 fe ff ff    	jne    80106ee7 <trap+0xa7>
80106fef:	e9 10 ff ff ff       	jmp    80106f04 <trap+0xc4>
80106ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106ff8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106ffc:	8b 77 38             	mov    0x38(%edi),%esi
80106fff:	e8 6c cb ff ff       	call   80103b70 <cpuid>
80107004:	56                   	push   %esi
80107005:	53                   	push   %ebx
80107006:	50                   	push   %eax
80107007:	68 00 90 10 80       	push   $0x80109000
8010700c:	e8 4f 96 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80107011:	e8 da ba ff ff       	call   80102af0 <lapiceoi>
    break;
80107016:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107019:	e8 72 cb ff ff       	call   80103b90 <myproc>
8010701e:	85 c0                	test   %eax,%eax
80107020:	0f 85 c1 fe ff ff    	jne    80106ee7 <trap+0xa7>
80107026:	e9 d9 fe ff ff       	jmp    80106f04 <trap+0xc4>
8010702b:	90                   	nop
8010702c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80107030:	e8 0b b3 ff ff       	call   80102340 <ideintr>
80107035:	e9 63 ff ff ff       	jmp    80106f9d <trap+0x15d>
8010703a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80107040:	e8 6b cf ff ff       	call   80103fb0 <exit>
80107045:	e9 0e ff ff ff       	jmp    80106f58 <trap+0x118>
8010704a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80107050:	e8 5b cf ff ff       	call   80103fb0 <exit>
80107055:	e9 aa fe ff ff       	jmp    80106f04 <trap+0xc4>
8010705a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80107060:	83 ec 0c             	sub    $0xc,%esp
80107063:	68 00 7d 11 80       	push   $0x80117d00
80107068:	e8 f3 e9 ff ff       	call   80105a60 <acquire>
      wakeup(&ticks);
8010706d:	c7 04 24 40 85 11 80 	movl   $0x80118540,(%esp)
      ticks++;
80107074:	83 05 40 85 11 80 01 	addl   $0x1,0x80118540
      wakeup(&ticks);
8010707b:	e8 60 d2 ff ff       	call   801042e0 <wakeup>
      release(&tickslock);
80107080:	c7 04 24 00 7d 11 80 	movl   $0x80117d00,(%esp)
80107087:	e8 94 ea ff ff       	call   80105b20 <release>
8010708c:	83 c4 10             	add    $0x10,%esp
8010708f:	e9 09 ff ff ff       	jmp    80106f9d <trap+0x15d>
80107094:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107097:	e8 d4 ca ff ff       	call   80103b70 <cpuid>
8010709c:	83 ec 0c             	sub    $0xc,%esp
8010709f:	56                   	push   %esi
801070a0:	53                   	push   %ebx
801070a1:	50                   	push   %eax
801070a2:	ff 77 30             	pushl  0x30(%edi)
801070a5:	68 24 90 10 80       	push   $0x80109024
801070aa:	e8 b1 95 ff ff       	call   80100660 <cprintf>
      panic("trap");
801070af:	83 c4 14             	add    $0x14,%esp
801070b2:	68 fb 8f 10 80       	push   $0x80108ffb
801070b7:	e8 d4 92 ff ff       	call   80100390 <panic>
801070bc:	66 90                	xchg   %ax,%ax
801070be:	66 90                	xchg   %ax,%ax

801070c0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801070c0:	a1 c0 ca 10 80       	mov    0x8010cac0,%eax
{
801070c5:	55                   	push   %ebp
801070c6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801070c8:	85 c0                	test   %eax,%eax
801070ca:	74 1c                	je     801070e8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801070cc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801070d1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801070d2:	a8 01                	test   $0x1,%al
801070d4:	74 12                	je     801070e8 <uartgetc+0x28>
801070d6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801070db:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801070dc:	0f b6 c0             	movzbl %al,%eax
}
801070df:	5d                   	pop    %ebp
801070e0:	c3                   	ret    
801070e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801070e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070ed:	5d                   	pop    %ebp
801070ee:	c3                   	ret    
801070ef:	90                   	nop

801070f0 <uartputc.part.0>:
uartputc(int c)
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	57                   	push   %edi
801070f4:	56                   	push   %esi
801070f5:	53                   	push   %ebx
801070f6:	89 c7                	mov    %eax,%edi
801070f8:	bb 80 00 00 00       	mov    $0x80,%ebx
801070fd:	be fd 03 00 00       	mov    $0x3fd,%esi
80107102:	83 ec 0c             	sub    $0xc,%esp
80107105:	eb 1b                	jmp    80107122 <uartputc.part.0+0x32>
80107107:	89 f6                	mov    %esi,%esi
80107109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80107110:	83 ec 0c             	sub    $0xc,%esp
80107113:	6a 0a                	push   $0xa
80107115:	e8 f6 b9 ff ff       	call   80102b10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010711a:	83 c4 10             	add    $0x10,%esp
8010711d:	83 eb 01             	sub    $0x1,%ebx
80107120:	74 07                	je     80107129 <uartputc.part.0+0x39>
80107122:	89 f2                	mov    %esi,%edx
80107124:	ec                   	in     (%dx),%al
80107125:	a8 20                	test   $0x20,%al
80107127:	74 e7                	je     80107110 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107129:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010712e:	89 f8                	mov    %edi,%eax
80107130:	ee                   	out    %al,(%dx)
}
80107131:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107134:	5b                   	pop    %ebx
80107135:	5e                   	pop    %esi
80107136:	5f                   	pop    %edi
80107137:	5d                   	pop    %ebp
80107138:	c3                   	ret    
80107139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107140 <uartinit>:
{
80107140:	55                   	push   %ebp
80107141:	31 c9                	xor    %ecx,%ecx
80107143:	89 c8                	mov    %ecx,%eax
80107145:	89 e5                	mov    %esp,%ebp
80107147:	57                   	push   %edi
80107148:	56                   	push   %esi
80107149:	53                   	push   %ebx
8010714a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010714f:	89 da                	mov    %ebx,%edx
80107151:	83 ec 0c             	sub    $0xc,%esp
80107154:	ee                   	out    %al,(%dx)
80107155:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010715a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010715f:	89 fa                	mov    %edi,%edx
80107161:	ee                   	out    %al,(%dx)
80107162:	b8 0c 00 00 00       	mov    $0xc,%eax
80107167:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010716c:	ee                   	out    %al,(%dx)
8010716d:	be f9 03 00 00       	mov    $0x3f9,%esi
80107172:	89 c8                	mov    %ecx,%eax
80107174:	89 f2                	mov    %esi,%edx
80107176:	ee                   	out    %al,(%dx)
80107177:	b8 03 00 00 00       	mov    $0x3,%eax
8010717c:	89 fa                	mov    %edi,%edx
8010717e:	ee                   	out    %al,(%dx)
8010717f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80107184:	89 c8                	mov    %ecx,%eax
80107186:	ee                   	out    %al,(%dx)
80107187:	b8 01 00 00 00       	mov    $0x1,%eax
8010718c:	89 f2                	mov    %esi,%edx
8010718e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010718f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107194:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80107195:	3c ff                	cmp    $0xff,%al
80107197:	74 5a                	je     801071f3 <uartinit+0xb3>
  uart = 1;
80107199:	c7 05 c0 ca 10 80 01 	movl   $0x1,0x8010cac0
801071a0:	00 00 00 
801071a3:	89 da                	mov    %ebx,%edx
801071a5:	ec                   	in     (%dx),%al
801071a6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801071ab:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801071ac:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801071af:	bb 1c 91 10 80       	mov    $0x8010911c,%ebx
  ioapicenable(IRQ_COM1, 0);
801071b4:	6a 00                	push   $0x0
801071b6:	6a 04                	push   $0x4
801071b8:	e8 b3 b4 ff ff       	call   80102670 <ioapicenable>
801071bd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801071c0:	b8 78 00 00 00       	mov    $0x78,%eax
801071c5:	eb 13                	jmp    801071da <uartinit+0x9a>
801071c7:	89 f6                	mov    %esi,%esi
801071c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801071d0:	83 c3 01             	add    $0x1,%ebx
801071d3:	0f be 03             	movsbl (%ebx),%eax
801071d6:	84 c0                	test   %al,%al
801071d8:	74 19                	je     801071f3 <uartinit+0xb3>
  if(!uart)
801071da:	8b 15 c0 ca 10 80    	mov    0x8010cac0,%edx
801071e0:	85 d2                	test   %edx,%edx
801071e2:	74 ec                	je     801071d0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801071e4:	83 c3 01             	add    $0x1,%ebx
801071e7:	e8 04 ff ff ff       	call   801070f0 <uartputc.part.0>
801071ec:	0f be 03             	movsbl (%ebx),%eax
801071ef:	84 c0                	test   %al,%al
801071f1:	75 e7                	jne    801071da <uartinit+0x9a>
}
801071f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071f6:	5b                   	pop    %ebx
801071f7:	5e                   	pop    %esi
801071f8:	5f                   	pop    %edi
801071f9:	5d                   	pop    %ebp
801071fa:	c3                   	ret    
801071fb:	90                   	nop
801071fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107200 <uartputc>:
  if(!uart)
80107200:	8b 15 c0 ca 10 80    	mov    0x8010cac0,%edx
{
80107206:	55                   	push   %ebp
80107207:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107209:	85 d2                	test   %edx,%edx
{
8010720b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010720e:	74 10                	je     80107220 <uartputc+0x20>
}
80107210:	5d                   	pop    %ebp
80107211:	e9 da fe ff ff       	jmp    801070f0 <uartputc.part.0>
80107216:	8d 76 00             	lea    0x0(%esi),%esi
80107219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107220:	5d                   	pop    %ebp
80107221:	c3                   	ret    
80107222:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107230 <uartintr>:

void
uartintr(void)
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80107236:	68 c0 70 10 80       	push   $0x801070c0
8010723b:	e8 d0 95 ff ff       	call   80100810 <consoleintr>
}
80107240:	83 c4 10             	add    $0x10,%esp
80107243:	c9                   	leave  
80107244:	c3                   	ret    

80107245 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107245:	6a 00                	push   $0x0
  pushl $0
80107247:	6a 00                	push   $0x0
  jmp alltraps
80107249:	e9 1c fb ff ff       	jmp    80106d6a <alltraps>

8010724e <vector1>:
.globl vector1
vector1:
  pushl $0
8010724e:	6a 00                	push   $0x0
  pushl $1
80107250:	6a 01                	push   $0x1
  jmp alltraps
80107252:	e9 13 fb ff ff       	jmp    80106d6a <alltraps>

80107257 <vector2>:
.globl vector2
vector2:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $2
80107259:	6a 02                	push   $0x2
  jmp alltraps
8010725b:	e9 0a fb ff ff       	jmp    80106d6a <alltraps>

80107260 <vector3>:
.globl vector3
vector3:
  pushl $0
80107260:	6a 00                	push   $0x0
  pushl $3
80107262:	6a 03                	push   $0x3
  jmp alltraps
80107264:	e9 01 fb ff ff       	jmp    80106d6a <alltraps>

80107269 <vector4>:
.globl vector4
vector4:
  pushl $0
80107269:	6a 00                	push   $0x0
  pushl $4
8010726b:	6a 04                	push   $0x4
  jmp alltraps
8010726d:	e9 f8 fa ff ff       	jmp    80106d6a <alltraps>

80107272 <vector5>:
.globl vector5
vector5:
  pushl $0
80107272:	6a 00                	push   $0x0
  pushl $5
80107274:	6a 05                	push   $0x5
  jmp alltraps
80107276:	e9 ef fa ff ff       	jmp    80106d6a <alltraps>

8010727b <vector6>:
.globl vector6
vector6:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $6
8010727d:	6a 06                	push   $0x6
  jmp alltraps
8010727f:	e9 e6 fa ff ff       	jmp    80106d6a <alltraps>

80107284 <vector7>:
.globl vector7
vector7:
  pushl $0
80107284:	6a 00                	push   $0x0
  pushl $7
80107286:	6a 07                	push   $0x7
  jmp alltraps
80107288:	e9 dd fa ff ff       	jmp    80106d6a <alltraps>

8010728d <vector8>:
.globl vector8
vector8:
  pushl $8
8010728d:	6a 08                	push   $0x8
  jmp alltraps
8010728f:	e9 d6 fa ff ff       	jmp    80106d6a <alltraps>

80107294 <vector9>:
.globl vector9
vector9:
  pushl $0
80107294:	6a 00                	push   $0x0
  pushl $9
80107296:	6a 09                	push   $0x9
  jmp alltraps
80107298:	e9 cd fa ff ff       	jmp    80106d6a <alltraps>

8010729d <vector10>:
.globl vector10
vector10:
  pushl $10
8010729d:	6a 0a                	push   $0xa
  jmp alltraps
8010729f:	e9 c6 fa ff ff       	jmp    80106d6a <alltraps>

801072a4 <vector11>:
.globl vector11
vector11:
  pushl $11
801072a4:	6a 0b                	push   $0xb
  jmp alltraps
801072a6:	e9 bf fa ff ff       	jmp    80106d6a <alltraps>

801072ab <vector12>:
.globl vector12
vector12:
  pushl $12
801072ab:	6a 0c                	push   $0xc
  jmp alltraps
801072ad:	e9 b8 fa ff ff       	jmp    80106d6a <alltraps>

801072b2 <vector13>:
.globl vector13
vector13:
  pushl $13
801072b2:	6a 0d                	push   $0xd
  jmp alltraps
801072b4:	e9 b1 fa ff ff       	jmp    80106d6a <alltraps>

801072b9 <vector14>:
.globl vector14
vector14:
  pushl $14
801072b9:	6a 0e                	push   $0xe
  jmp alltraps
801072bb:	e9 aa fa ff ff       	jmp    80106d6a <alltraps>

801072c0 <vector15>:
.globl vector15
vector15:
  pushl $0
801072c0:	6a 00                	push   $0x0
  pushl $15
801072c2:	6a 0f                	push   $0xf
  jmp alltraps
801072c4:	e9 a1 fa ff ff       	jmp    80106d6a <alltraps>

801072c9 <vector16>:
.globl vector16
vector16:
  pushl $0
801072c9:	6a 00                	push   $0x0
  pushl $16
801072cb:	6a 10                	push   $0x10
  jmp alltraps
801072cd:	e9 98 fa ff ff       	jmp    80106d6a <alltraps>

801072d2 <vector17>:
.globl vector17
vector17:
  pushl $17
801072d2:	6a 11                	push   $0x11
  jmp alltraps
801072d4:	e9 91 fa ff ff       	jmp    80106d6a <alltraps>

801072d9 <vector18>:
.globl vector18
vector18:
  pushl $0
801072d9:	6a 00                	push   $0x0
  pushl $18
801072db:	6a 12                	push   $0x12
  jmp alltraps
801072dd:	e9 88 fa ff ff       	jmp    80106d6a <alltraps>

801072e2 <vector19>:
.globl vector19
vector19:
  pushl $0
801072e2:	6a 00                	push   $0x0
  pushl $19
801072e4:	6a 13                	push   $0x13
  jmp alltraps
801072e6:	e9 7f fa ff ff       	jmp    80106d6a <alltraps>

801072eb <vector20>:
.globl vector20
vector20:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $20
801072ed:	6a 14                	push   $0x14
  jmp alltraps
801072ef:	e9 76 fa ff ff       	jmp    80106d6a <alltraps>

801072f4 <vector21>:
.globl vector21
vector21:
  pushl $0
801072f4:	6a 00                	push   $0x0
  pushl $21
801072f6:	6a 15                	push   $0x15
  jmp alltraps
801072f8:	e9 6d fa ff ff       	jmp    80106d6a <alltraps>

801072fd <vector22>:
.globl vector22
vector22:
  pushl $0
801072fd:	6a 00                	push   $0x0
  pushl $22
801072ff:	6a 16                	push   $0x16
  jmp alltraps
80107301:	e9 64 fa ff ff       	jmp    80106d6a <alltraps>

80107306 <vector23>:
.globl vector23
vector23:
  pushl $0
80107306:	6a 00                	push   $0x0
  pushl $23
80107308:	6a 17                	push   $0x17
  jmp alltraps
8010730a:	e9 5b fa ff ff       	jmp    80106d6a <alltraps>

8010730f <vector24>:
.globl vector24
vector24:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $24
80107311:	6a 18                	push   $0x18
  jmp alltraps
80107313:	e9 52 fa ff ff       	jmp    80106d6a <alltraps>

80107318 <vector25>:
.globl vector25
vector25:
  pushl $0
80107318:	6a 00                	push   $0x0
  pushl $25
8010731a:	6a 19                	push   $0x19
  jmp alltraps
8010731c:	e9 49 fa ff ff       	jmp    80106d6a <alltraps>

80107321 <vector26>:
.globl vector26
vector26:
  pushl $0
80107321:	6a 00                	push   $0x0
  pushl $26
80107323:	6a 1a                	push   $0x1a
  jmp alltraps
80107325:	e9 40 fa ff ff       	jmp    80106d6a <alltraps>

8010732a <vector27>:
.globl vector27
vector27:
  pushl $0
8010732a:	6a 00                	push   $0x0
  pushl $27
8010732c:	6a 1b                	push   $0x1b
  jmp alltraps
8010732e:	e9 37 fa ff ff       	jmp    80106d6a <alltraps>

80107333 <vector28>:
.globl vector28
vector28:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $28
80107335:	6a 1c                	push   $0x1c
  jmp alltraps
80107337:	e9 2e fa ff ff       	jmp    80106d6a <alltraps>

8010733c <vector29>:
.globl vector29
vector29:
  pushl $0
8010733c:	6a 00                	push   $0x0
  pushl $29
8010733e:	6a 1d                	push   $0x1d
  jmp alltraps
80107340:	e9 25 fa ff ff       	jmp    80106d6a <alltraps>

80107345 <vector30>:
.globl vector30
vector30:
  pushl $0
80107345:	6a 00                	push   $0x0
  pushl $30
80107347:	6a 1e                	push   $0x1e
  jmp alltraps
80107349:	e9 1c fa ff ff       	jmp    80106d6a <alltraps>

8010734e <vector31>:
.globl vector31
vector31:
  pushl $0
8010734e:	6a 00                	push   $0x0
  pushl $31
80107350:	6a 1f                	push   $0x1f
  jmp alltraps
80107352:	e9 13 fa ff ff       	jmp    80106d6a <alltraps>

80107357 <vector32>:
.globl vector32
vector32:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $32
80107359:	6a 20                	push   $0x20
  jmp alltraps
8010735b:	e9 0a fa ff ff       	jmp    80106d6a <alltraps>

80107360 <vector33>:
.globl vector33
vector33:
  pushl $0
80107360:	6a 00                	push   $0x0
  pushl $33
80107362:	6a 21                	push   $0x21
  jmp alltraps
80107364:	e9 01 fa ff ff       	jmp    80106d6a <alltraps>

80107369 <vector34>:
.globl vector34
vector34:
  pushl $0
80107369:	6a 00                	push   $0x0
  pushl $34
8010736b:	6a 22                	push   $0x22
  jmp alltraps
8010736d:	e9 f8 f9 ff ff       	jmp    80106d6a <alltraps>

80107372 <vector35>:
.globl vector35
vector35:
  pushl $0
80107372:	6a 00                	push   $0x0
  pushl $35
80107374:	6a 23                	push   $0x23
  jmp alltraps
80107376:	e9 ef f9 ff ff       	jmp    80106d6a <alltraps>

8010737b <vector36>:
.globl vector36
vector36:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $36
8010737d:	6a 24                	push   $0x24
  jmp alltraps
8010737f:	e9 e6 f9 ff ff       	jmp    80106d6a <alltraps>

80107384 <vector37>:
.globl vector37
vector37:
  pushl $0
80107384:	6a 00                	push   $0x0
  pushl $37
80107386:	6a 25                	push   $0x25
  jmp alltraps
80107388:	e9 dd f9 ff ff       	jmp    80106d6a <alltraps>

8010738d <vector38>:
.globl vector38
vector38:
  pushl $0
8010738d:	6a 00                	push   $0x0
  pushl $38
8010738f:	6a 26                	push   $0x26
  jmp alltraps
80107391:	e9 d4 f9 ff ff       	jmp    80106d6a <alltraps>

80107396 <vector39>:
.globl vector39
vector39:
  pushl $0
80107396:	6a 00                	push   $0x0
  pushl $39
80107398:	6a 27                	push   $0x27
  jmp alltraps
8010739a:	e9 cb f9 ff ff       	jmp    80106d6a <alltraps>

8010739f <vector40>:
.globl vector40
vector40:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $40
801073a1:	6a 28                	push   $0x28
  jmp alltraps
801073a3:	e9 c2 f9 ff ff       	jmp    80106d6a <alltraps>

801073a8 <vector41>:
.globl vector41
vector41:
  pushl $0
801073a8:	6a 00                	push   $0x0
  pushl $41
801073aa:	6a 29                	push   $0x29
  jmp alltraps
801073ac:	e9 b9 f9 ff ff       	jmp    80106d6a <alltraps>

801073b1 <vector42>:
.globl vector42
vector42:
  pushl $0
801073b1:	6a 00                	push   $0x0
  pushl $42
801073b3:	6a 2a                	push   $0x2a
  jmp alltraps
801073b5:	e9 b0 f9 ff ff       	jmp    80106d6a <alltraps>

801073ba <vector43>:
.globl vector43
vector43:
  pushl $0
801073ba:	6a 00                	push   $0x0
  pushl $43
801073bc:	6a 2b                	push   $0x2b
  jmp alltraps
801073be:	e9 a7 f9 ff ff       	jmp    80106d6a <alltraps>

801073c3 <vector44>:
.globl vector44
vector44:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $44
801073c5:	6a 2c                	push   $0x2c
  jmp alltraps
801073c7:	e9 9e f9 ff ff       	jmp    80106d6a <alltraps>

801073cc <vector45>:
.globl vector45
vector45:
  pushl $0
801073cc:	6a 00                	push   $0x0
  pushl $45
801073ce:	6a 2d                	push   $0x2d
  jmp alltraps
801073d0:	e9 95 f9 ff ff       	jmp    80106d6a <alltraps>

801073d5 <vector46>:
.globl vector46
vector46:
  pushl $0
801073d5:	6a 00                	push   $0x0
  pushl $46
801073d7:	6a 2e                	push   $0x2e
  jmp alltraps
801073d9:	e9 8c f9 ff ff       	jmp    80106d6a <alltraps>

801073de <vector47>:
.globl vector47
vector47:
  pushl $0
801073de:	6a 00                	push   $0x0
  pushl $47
801073e0:	6a 2f                	push   $0x2f
  jmp alltraps
801073e2:	e9 83 f9 ff ff       	jmp    80106d6a <alltraps>

801073e7 <vector48>:
.globl vector48
vector48:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $48
801073e9:	6a 30                	push   $0x30
  jmp alltraps
801073eb:	e9 7a f9 ff ff       	jmp    80106d6a <alltraps>

801073f0 <vector49>:
.globl vector49
vector49:
  pushl $0
801073f0:	6a 00                	push   $0x0
  pushl $49
801073f2:	6a 31                	push   $0x31
  jmp alltraps
801073f4:	e9 71 f9 ff ff       	jmp    80106d6a <alltraps>

801073f9 <vector50>:
.globl vector50
vector50:
  pushl $0
801073f9:	6a 00                	push   $0x0
  pushl $50
801073fb:	6a 32                	push   $0x32
  jmp alltraps
801073fd:	e9 68 f9 ff ff       	jmp    80106d6a <alltraps>

80107402 <vector51>:
.globl vector51
vector51:
  pushl $0
80107402:	6a 00                	push   $0x0
  pushl $51
80107404:	6a 33                	push   $0x33
  jmp alltraps
80107406:	e9 5f f9 ff ff       	jmp    80106d6a <alltraps>

8010740b <vector52>:
.globl vector52
vector52:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $52
8010740d:	6a 34                	push   $0x34
  jmp alltraps
8010740f:	e9 56 f9 ff ff       	jmp    80106d6a <alltraps>

80107414 <vector53>:
.globl vector53
vector53:
  pushl $0
80107414:	6a 00                	push   $0x0
  pushl $53
80107416:	6a 35                	push   $0x35
  jmp alltraps
80107418:	e9 4d f9 ff ff       	jmp    80106d6a <alltraps>

8010741d <vector54>:
.globl vector54
vector54:
  pushl $0
8010741d:	6a 00                	push   $0x0
  pushl $54
8010741f:	6a 36                	push   $0x36
  jmp alltraps
80107421:	e9 44 f9 ff ff       	jmp    80106d6a <alltraps>

80107426 <vector55>:
.globl vector55
vector55:
  pushl $0
80107426:	6a 00                	push   $0x0
  pushl $55
80107428:	6a 37                	push   $0x37
  jmp alltraps
8010742a:	e9 3b f9 ff ff       	jmp    80106d6a <alltraps>

8010742f <vector56>:
.globl vector56
vector56:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $56
80107431:	6a 38                	push   $0x38
  jmp alltraps
80107433:	e9 32 f9 ff ff       	jmp    80106d6a <alltraps>

80107438 <vector57>:
.globl vector57
vector57:
  pushl $0
80107438:	6a 00                	push   $0x0
  pushl $57
8010743a:	6a 39                	push   $0x39
  jmp alltraps
8010743c:	e9 29 f9 ff ff       	jmp    80106d6a <alltraps>

80107441 <vector58>:
.globl vector58
vector58:
  pushl $0
80107441:	6a 00                	push   $0x0
  pushl $58
80107443:	6a 3a                	push   $0x3a
  jmp alltraps
80107445:	e9 20 f9 ff ff       	jmp    80106d6a <alltraps>

8010744a <vector59>:
.globl vector59
vector59:
  pushl $0
8010744a:	6a 00                	push   $0x0
  pushl $59
8010744c:	6a 3b                	push   $0x3b
  jmp alltraps
8010744e:	e9 17 f9 ff ff       	jmp    80106d6a <alltraps>

80107453 <vector60>:
.globl vector60
vector60:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $60
80107455:	6a 3c                	push   $0x3c
  jmp alltraps
80107457:	e9 0e f9 ff ff       	jmp    80106d6a <alltraps>

8010745c <vector61>:
.globl vector61
vector61:
  pushl $0
8010745c:	6a 00                	push   $0x0
  pushl $61
8010745e:	6a 3d                	push   $0x3d
  jmp alltraps
80107460:	e9 05 f9 ff ff       	jmp    80106d6a <alltraps>

80107465 <vector62>:
.globl vector62
vector62:
  pushl $0
80107465:	6a 00                	push   $0x0
  pushl $62
80107467:	6a 3e                	push   $0x3e
  jmp alltraps
80107469:	e9 fc f8 ff ff       	jmp    80106d6a <alltraps>

8010746e <vector63>:
.globl vector63
vector63:
  pushl $0
8010746e:	6a 00                	push   $0x0
  pushl $63
80107470:	6a 3f                	push   $0x3f
  jmp alltraps
80107472:	e9 f3 f8 ff ff       	jmp    80106d6a <alltraps>

80107477 <vector64>:
.globl vector64
vector64:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $64
80107479:	6a 40                	push   $0x40
  jmp alltraps
8010747b:	e9 ea f8 ff ff       	jmp    80106d6a <alltraps>

80107480 <vector65>:
.globl vector65
vector65:
  pushl $0
80107480:	6a 00                	push   $0x0
  pushl $65
80107482:	6a 41                	push   $0x41
  jmp alltraps
80107484:	e9 e1 f8 ff ff       	jmp    80106d6a <alltraps>

80107489 <vector66>:
.globl vector66
vector66:
  pushl $0
80107489:	6a 00                	push   $0x0
  pushl $66
8010748b:	6a 42                	push   $0x42
  jmp alltraps
8010748d:	e9 d8 f8 ff ff       	jmp    80106d6a <alltraps>

80107492 <vector67>:
.globl vector67
vector67:
  pushl $0
80107492:	6a 00                	push   $0x0
  pushl $67
80107494:	6a 43                	push   $0x43
  jmp alltraps
80107496:	e9 cf f8 ff ff       	jmp    80106d6a <alltraps>

8010749b <vector68>:
.globl vector68
vector68:
  pushl $0
8010749b:	6a 00                	push   $0x0
  pushl $68
8010749d:	6a 44                	push   $0x44
  jmp alltraps
8010749f:	e9 c6 f8 ff ff       	jmp    80106d6a <alltraps>

801074a4 <vector69>:
.globl vector69
vector69:
  pushl $0
801074a4:	6a 00                	push   $0x0
  pushl $69
801074a6:	6a 45                	push   $0x45
  jmp alltraps
801074a8:	e9 bd f8 ff ff       	jmp    80106d6a <alltraps>

801074ad <vector70>:
.globl vector70
vector70:
  pushl $0
801074ad:	6a 00                	push   $0x0
  pushl $70
801074af:	6a 46                	push   $0x46
  jmp alltraps
801074b1:	e9 b4 f8 ff ff       	jmp    80106d6a <alltraps>

801074b6 <vector71>:
.globl vector71
vector71:
  pushl $0
801074b6:	6a 00                	push   $0x0
  pushl $71
801074b8:	6a 47                	push   $0x47
  jmp alltraps
801074ba:	e9 ab f8 ff ff       	jmp    80106d6a <alltraps>

801074bf <vector72>:
.globl vector72
vector72:
  pushl $0
801074bf:	6a 00                	push   $0x0
  pushl $72
801074c1:	6a 48                	push   $0x48
  jmp alltraps
801074c3:	e9 a2 f8 ff ff       	jmp    80106d6a <alltraps>

801074c8 <vector73>:
.globl vector73
vector73:
  pushl $0
801074c8:	6a 00                	push   $0x0
  pushl $73
801074ca:	6a 49                	push   $0x49
  jmp alltraps
801074cc:	e9 99 f8 ff ff       	jmp    80106d6a <alltraps>

801074d1 <vector74>:
.globl vector74
vector74:
  pushl $0
801074d1:	6a 00                	push   $0x0
  pushl $74
801074d3:	6a 4a                	push   $0x4a
  jmp alltraps
801074d5:	e9 90 f8 ff ff       	jmp    80106d6a <alltraps>

801074da <vector75>:
.globl vector75
vector75:
  pushl $0
801074da:	6a 00                	push   $0x0
  pushl $75
801074dc:	6a 4b                	push   $0x4b
  jmp alltraps
801074de:	e9 87 f8 ff ff       	jmp    80106d6a <alltraps>

801074e3 <vector76>:
.globl vector76
vector76:
  pushl $0
801074e3:	6a 00                	push   $0x0
  pushl $76
801074e5:	6a 4c                	push   $0x4c
  jmp alltraps
801074e7:	e9 7e f8 ff ff       	jmp    80106d6a <alltraps>

801074ec <vector77>:
.globl vector77
vector77:
  pushl $0
801074ec:	6a 00                	push   $0x0
  pushl $77
801074ee:	6a 4d                	push   $0x4d
  jmp alltraps
801074f0:	e9 75 f8 ff ff       	jmp    80106d6a <alltraps>

801074f5 <vector78>:
.globl vector78
vector78:
  pushl $0
801074f5:	6a 00                	push   $0x0
  pushl $78
801074f7:	6a 4e                	push   $0x4e
  jmp alltraps
801074f9:	e9 6c f8 ff ff       	jmp    80106d6a <alltraps>

801074fe <vector79>:
.globl vector79
vector79:
  pushl $0
801074fe:	6a 00                	push   $0x0
  pushl $79
80107500:	6a 4f                	push   $0x4f
  jmp alltraps
80107502:	e9 63 f8 ff ff       	jmp    80106d6a <alltraps>

80107507 <vector80>:
.globl vector80
vector80:
  pushl $0
80107507:	6a 00                	push   $0x0
  pushl $80
80107509:	6a 50                	push   $0x50
  jmp alltraps
8010750b:	e9 5a f8 ff ff       	jmp    80106d6a <alltraps>

80107510 <vector81>:
.globl vector81
vector81:
  pushl $0
80107510:	6a 00                	push   $0x0
  pushl $81
80107512:	6a 51                	push   $0x51
  jmp alltraps
80107514:	e9 51 f8 ff ff       	jmp    80106d6a <alltraps>

80107519 <vector82>:
.globl vector82
vector82:
  pushl $0
80107519:	6a 00                	push   $0x0
  pushl $82
8010751b:	6a 52                	push   $0x52
  jmp alltraps
8010751d:	e9 48 f8 ff ff       	jmp    80106d6a <alltraps>

80107522 <vector83>:
.globl vector83
vector83:
  pushl $0
80107522:	6a 00                	push   $0x0
  pushl $83
80107524:	6a 53                	push   $0x53
  jmp alltraps
80107526:	e9 3f f8 ff ff       	jmp    80106d6a <alltraps>

8010752b <vector84>:
.globl vector84
vector84:
  pushl $0
8010752b:	6a 00                	push   $0x0
  pushl $84
8010752d:	6a 54                	push   $0x54
  jmp alltraps
8010752f:	e9 36 f8 ff ff       	jmp    80106d6a <alltraps>

80107534 <vector85>:
.globl vector85
vector85:
  pushl $0
80107534:	6a 00                	push   $0x0
  pushl $85
80107536:	6a 55                	push   $0x55
  jmp alltraps
80107538:	e9 2d f8 ff ff       	jmp    80106d6a <alltraps>

8010753d <vector86>:
.globl vector86
vector86:
  pushl $0
8010753d:	6a 00                	push   $0x0
  pushl $86
8010753f:	6a 56                	push   $0x56
  jmp alltraps
80107541:	e9 24 f8 ff ff       	jmp    80106d6a <alltraps>

80107546 <vector87>:
.globl vector87
vector87:
  pushl $0
80107546:	6a 00                	push   $0x0
  pushl $87
80107548:	6a 57                	push   $0x57
  jmp alltraps
8010754a:	e9 1b f8 ff ff       	jmp    80106d6a <alltraps>

8010754f <vector88>:
.globl vector88
vector88:
  pushl $0
8010754f:	6a 00                	push   $0x0
  pushl $88
80107551:	6a 58                	push   $0x58
  jmp alltraps
80107553:	e9 12 f8 ff ff       	jmp    80106d6a <alltraps>

80107558 <vector89>:
.globl vector89
vector89:
  pushl $0
80107558:	6a 00                	push   $0x0
  pushl $89
8010755a:	6a 59                	push   $0x59
  jmp alltraps
8010755c:	e9 09 f8 ff ff       	jmp    80106d6a <alltraps>

80107561 <vector90>:
.globl vector90
vector90:
  pushl $0
80107561:	6a 00                	push   $0x0
  pushl $90
80107563:	6a 5a                	push   $0x5a
  jmp alltraps
80107565:	e9 00 f8 ff ff       	jmp    80106d6a <alltraps>

8010756a <vector91>:
.globl vector91
vector91:
  pushl $0
8010756a:	6a 00                	push   $0x0
  pushl $91
8010756c:	6a 5b                	push   $0x5b
  jmp alltraps
8010756e:	e9 f7 f7 ff ff       	jmp    80106d6a <alltraps>

80107573 <vector92>:
.globl vector92
vector92:
  pushl $0
80107573:	6a 00                	push   $0x0
  pushl $92
80107575:	6a 5c                	push   $0x5c
  jmp alltraps
80107577:	e9 ee f7 ff ff       	jmp    80106d6a <alltraps>

8010757c <vector93>:
.globl vector93
vector93:
  pushl $0
8010757c:	6a 00                	push   $0x0
  pushl $93
8010757e:	6a 5d                	push   $0x5d
  jmp alltraps
80107580:	e9 e5 f7 ff ff       	jmp    80106d6a <alltraps>

80107585 <vector94>:
.globl vector94
vector94:
  pushl $0
80107585:	6a 00                	push   $0x0
  pushl $94
80107587:	6a 5e                	push   $0x5e
  jmp alltraps
80107589:	e9 dc f7 ff ff       	jmp    80106d6a <alltraps>

8010758e <vector95>:
.globl vector95
vector95:
  pushl $0
8010758e:	6a 00                	push   $0x0
  pushl $95
80107590:	6a 5f                	push   $0x5f
  jmp alltraps
80107592:	e9 d3 f7 ff ff       	jmp    80106d6a <alltraps>

80107597 <vector96>:
.globl vector96
vector96:
  pushl $0
80107597:	6a 00                	push   $0x0
  pushl $96
80107599:	6a 60                	push   $0x60
  jmp alltraps
8010759b:	e9 ca f7 ff ff       	jmp    80106d6a <alltraps>

801075a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801075a0:	6a 00                	push   $0x0
  pushl $97
801075a2:	6a 61                	push   $0x61
  jmp alltraps
801075a4:	e9 c1 f7 ff ff       	jmp    80106d6a <alltraps>

801075a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801075a9:	6a 00                	push   $0x0
  pushl $98
801075ab:	6a 62                	push   $0x62
  jmp alltraps
801075ad:	e9 b8 f7 ff ff       	jmp    80106d6a <alltraps>

801075b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801075b2:	6a 00                	push   $0x0
  pushl $99
801075b4:	6a 63                	push   $0x63
  jmp alltraps
801075b6:	e9 af f7 ff ff       	jmp    80106d6a <alltraps>

801075bb <vector100>:
.globl vector100
vector100:
  pushl $0
801075bb:	6a 00                	push   $0x0
  pushl $100
801075bd:	6a 64                	push   $0x64
  jmp alltraps
801075bf:	e9 a6 f7 ff ff       	jmp    80106d6a <alltraps>

801075c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801075c4:	6a 00                	push   $0x0
  pushl $101
801075c6:	6a 65                	push   $0x65
  jmp alltraps
801075c8:	e9 9d f7 ff ff       	jmp    80106d6a <alltraps>

801075cd <vector102>:
.globl vector102
vector102:
  pushl $0
801075cd:	6a 00                	push   $0x0
  pushl $102
801075cf:	6a 66                	push   $0x66
  jmp alltraps
801075d1:	e9 94 f7 ff ff       	jmp    80106d6a <alltraps>

801075d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801075d6:	6a 00                	push   $0x0
  pushl $103
801075d8:	6a 67                	push   $0x67
  jmp alltraps
801075da:	e9 8b f7 ff ff       	jmp    80106d6a <alltraps>

801075df <vector104>:
.globl vector104
vector104:
  pushl $0
801075df:	6a 00                	push   $0x0
  pushl $104
801075e1:	6a 68                	push   $0x68
  jmp alltraps
801075e3:	e9 82 f7 ff ff       	jmp    80106d6a <alltraps>

801075e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801075e8:	6a 00                	push   $0x0
  pushl $105
801075ea:	6a 69                	push   $0x69
  jmp alltraps
801075ec:	e9 79 f7 ff ff       	jmp    80106d6a <alltraps>

801075f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801075f1:	6a 00                	push   $0x0
  pushl $106
801075f3:	6a 6a                	push   $0x6a
  jmp alltraps
801075f5:	e9 70 f7 ff ff       	jmp    80106d6a <alltraps>

801075fa <vector107>:
.globl vector107
vector107:
  pushl $0
801075fa:	6a 00                	push   $0x0
  pushl $107
801075fc:	6a 6b                	push   $0x6b
  jmp alltraps
801075fe:	e9 67 f7 ff ff       	jmp    80106d6a <alltraps>

80107603 <vector108>:
.globl vector108
vector108:
  pushl $0
80107603:	6a 00                	push   $0x0
  pushl $108
80107605:	6a 6c                	push   $0x6c
  jmp alltraps
80107607:	e9 5e f7 ff ff       	jmp    80106d6a <alltraps>

8010760c <vector109>:
.globl vector109
vector109:
  pushl $0
8010760c:	6a 00                	push   $0x0
  pushl $109
8010760e:	6a 6d                	push   $0x6d
  jmp alltraps
80107610:	e9 55 f7 ff ff       	jmp    80106d6a <alltraps>

80107615 <vector110>:
.globl vector110
vector110:
  pushl $0
80107615:	6a 00                	push   $0x0
  pushl $110
80107617:	6a 6e                	push   $0x6e
  jmp alltraps
80107619:	e9 4c f7 ff ff       	jmp    80106d6a <alltraps>

8010761e <vector111>:
.globl vector111
vector111:
  pushl $0
8010761e:	6a 00                	push   $0x0
  pushl $111
80107620:	6a 6f                	push   $0x6f
  jmp alltraps
80107622:	e9 43 f7 ff ff       	jmp    80106d6a <alltraps>

80107627 <vector112>:
.globl vector112
vector112:
  pushl $0
80107627:	6a 00                	push   $0x0
  pushl $112
80107629:	6a 70                	push   $0x70
  jmp alltraps
8010762b:	e9 3a f7 ff ff       	jmp    80106d6a <alltraps>

80107630 <vector113>:
.globl vector113
vector113:
  pushl $0
80107630:	6a 00                	push   $0x0
  pushl $113
80107632:	6a 71                	push   $0x71
  jmp alltraps
80107634:	e9 31 f7 ff ff       	jmp    80106d6a <alltraps>

80107639 <vector114>:
.globl vector114
vector114:
  pushl $0
80107639:	6a 00                	push   $0x0
  pushl $114
8010763b:	6a 72                	push   $0x72
  jmp alltraps
8010763d:	e9 28 f7 ff ff       	jmp    80106d6a <alltraps>

80107642 <vector115>:
.globl vector115
vector115:
  pushl $0
80107642:	6a 00                	push   $0x0
  pushl $115
80107644:	6a 73                	push   $0x73
  jmp alltraps
80107646:	e9 1f f7 ff ff       	jmp    80106d6a <alltraps>

8010764b <vector116>:
.globl vector116
vector116:
  pushl $0
8010764b:	6a 00                	push   $0x0
  pushl $116
8010764d:	6a 74                	push   $0x74
  jmp alltraps
8010764f:	e9 16 f7 ff ff       	jmp    80106d6a <alltraps>

80107654 <vector117>:
.globl vector117
vector117:
  pushl $0
80107654:	6a 00                	push   $0x0
  pushl $117
80107656:	6a 75                	push   $0x75
  jmp alltraps
80107658:	e9 0d f7 ff ff       	jmp    80106d6a <alltraps>

8010765d <vector118>:
.globl vector118
vector118:
  pushl $0
8010765d:	6a 00                	push   $0x0
  pushl $118
8010765f:	6a 76                	push   $0x76
  jmp alltraps
80107661:	e9 04 f7 ff ff       	jmp    80106d6a <alltraps>

80107666 <vector119>:
.globl vector119
vector119:
  pushl $0
80107666:	6a 00                	push   $0x0
  pushl $119
80107668:	6a 77                	push   $0x77
  jmp alltraps
8010766a:	e9 fb f6 ff ff       	jmp    80106d6a <alltraps>

8010766f <vector120>:
.globl vector120
vector120:
  pushl $0
8010766f:	6a 00                	push   $0x0
  pushl $120
80107671:	6a 78                	push   $0x78
  jmp alltraps
80107673:	e9 f2 f6 ff ff       	jmp    80106d6a <alltraps>

80107678 <vector121>:
.globl vector121
vector121:
  pushl $0
80107678:	6a 00                	push   $0x0
  pushl $121
8010767a:	6a 79                	push   $0x79
  jmp alltraps
8010767c:	e9 e9 f6 ff ff       	jmp    80106d6a <alltraps>

80107681 <vector122>:
.globl vector122
vector122:
  pushl $0
80107681:	6a 00                	push   $0x0
  pushl $122
80107683:	6a 7a                	push   $0x7a
  jmp alltraps
80107685:	e9 e0 f6 ff ff       	jmp    80106d6a <alltraps>

8010768a <vector123>:
.globl vector123
vector123:
  pushl $0
8010768a:	6a 00                	push   $0x0
  pushl $123
8010768c:	6a 7b                	push   $0x7b
  jmp alltraps
8010768e:	e9 d7 f6 ff ff       	jmp    80106d6a <alltraps>

80107693 <vector124>:
.globl vector124
vector124:
  pushl $0
80107693:	6a 00                	push   $0x0
  pushl $124
80107695:	6a 7c                	push   $0x7c
  jmp alltraps
80107697:	e9 ce f6 ff ff       	jmp    80106d6a <alltraps>

8010769c <vector125>:
.globl vector125
vector125:
  pushl $0
8010769c:	6a 00                	push   $0x0
  pushl $125
8010769e:	6a 7d                	push   $0x7d
  jmp alltraps
801076a0:	e9 c5 f6 ff ff       	jmp    80106d6a <alltraps>

801076a5 <vector126>:
.globl vector126
vector126:
  pushl $0
801076a5:	6a 00                	push   $0x0
  pushl $126
801076a7:	6a 7e                	push   $0x7e
  jmp alltraps
801076a9:	e9 bc f6 ff ff       	jmp    80106d6a <alltraps>

801076ae <vector127>:
.globl vector127
vector127:
  pushl $0
801076ae:	6a 00                	push   $0x0
  pushl $127
801076b0:	6a 7f                	push   $0x7f
  jmp alltraps
801076b2:	e9 b3 f6 ff ff       	jmp    80106d6a <alltraps>

801076b7 <vector128>:
.globl vector128
vector128:
  pushl $0
801076b7:	6a 00                	push   $0x0
  pushl $128
801076b9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801076be:	e9 a7 f6 ff ff       	jmp    80106d6a <alltraps>

801076c3 <vector129>:
.globl vector129
vector129:
  pushl $0
801076c3:	6a 00                	push   $0x0
  pushl $129
801076c5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801076ca:	e9 9b f6 ff ff       	jmp    80106d6a <alltraps>

801076cf <vector130>:
.globl vector130
vector130:
  pushl $0
801076cf:	6a 00                	push   $0x0
  pushl $130
801076d1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801076d6:	e9 8f f6 ff ff       	jmp    80106d6a <alltraps>

801076db <vector131>:
.globl vector131
vector131:
  pushl $0
801076db:	6a 00                	push   $0x0
  pushl $131
801076dd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801076e2:	e9 83 f6 ff ff       	jmp    80106d6a <alltraps>

801076e7 <vector132>:
.globl vector132
vector132:
  pushl $0
801076e7:	6a 00                	push   $0x0
  pushl $132
801076e9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801076ee:	e9 77 f6 ff ff       	jmp    80106d6a <alltraps>

801076f3 <vector133>:
.globl vector133
vector133:
  pushl $0
801076f3:	6a 00                	push   $0x0
  pushl $133
801076f5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801076fa:	e9 6b f6 ff ff       	jmp    80106d6a <alltraps>

801076ff <vector134>:
.globl vector134
vector134:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $134
80107701:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107706:	e9 5f f6 ff ff       	jmp    80106d6a <alltraps>

8010770b <vector135>:
.globl vector135
vector135:
  pushl $0
8010770b:	6a 00                	push   $0x0
  pushl $135
8010770d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107712:	e9 53 f6 ff ff       	jmp    80106d6a <alltraps>

80107717 <vector136>:
.globl vector136
vector136:
  pushl $0
80107717:	6a 00                	push   $0x0
  pushl $136
80107719:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010771e:	e9 47 f6 ff ff       	jmp    80106d6a <alltraps>

80107723 <vector137>:
.globl vector137
vector137:
  pushl $0
80107723:	6a 00                	push   $0x0
  pushl $137
80107725:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010772a:	e9 3b f6 ff ff       	jmp    80106d6a <alltraps>

8010772f <vector138>:
.globl vector138
vector138:
  pushl $0
8010772f:	6a 00                	push   $0x0
  pushl $138
80107731:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107736:	e9 2f f6 ff ff       	jmp    80106d6a <alltraps>

8010773b <vector139>:
.globl vector139
vector139:
  pushl $0
8010773b:	6a 00                	push   $0x0
  pushl $139
8010773d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107742:	e9 23 f6 ff ff       	jmp    80106d6a <alltraps>

80107747 <vector140>:
.globl vector140
vector140:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $140
80107749:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010774e:	e9 17 f6 ff ff       	jmp    80106d6a <alltraps>

80107753 <vector141>:
.globl vector141
vector141:
  pushl $0
80107753:	6a 00                	push   $0x0
  pushl $141
80107755:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010775a:	e9 0b f6 ff ff       	jmp    80106d6a <alltraps>

8010775f <vector142>:
.globl vector142
vector142:
  pushl $0
8010775f:	6a 00                	push   $0x0
  pushl $142
80107761:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107766:	e9 ff f5 ff ff       	jmp    80106d6a <alltraps>

8010776b <vector143>:
.globl vector143
vector143:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $143
8010776d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107772:	e9 f3 f5 ff ff       	jmp    80106d6a <alltraps>

80107777 <vector144>:
.globl vector144
vector144:
  pushl $0
80107777:	6a 00                	push   $0x0
  pushl $144
80107779:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010777e:	e9 e7 f5 ff ff       	jmp    80106d6a <alltraps>

80107783 <vector145>:
.globl vector145
vector145:
  pushl $0
80107783:	6a 00                	push   $0x0
  pushl $145
80107785:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010778a:	e9 db f5 ff ff       	jmp    80106d6a <alltraps>

8010778f <vector146>:
.globl vector146
vector146:
  pushl $0
8010778f:	6a 00                	push   $0x0
  pushl $146
80107791:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107796:	e9 cf f5 ff ff       	jmp    80106d6a <alltraps>

8010779b <vector147>:
.globl vector147
vector147:
  pushl $0
8010779b:	6a 00                	push   $0x0
  pushl $147
8010779d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801077a2:	e9 c3 f5 ff ff       	jmp    80106d6a <alltraps>

801077a7 <vector148>:
.globl vector148
vector148:
  pushl $0
801077a7:	6a 00                	push   $0x0
  pushl $148
801077a9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801077ae:	e9 b7 f5 ff ff       	jmp    80106d6a <alltraps>

801077b3 <vector149>:
.globl vector149
vector149:
  pushl $0
801077b3:	6a 00                	push   $0x0
  pushl $149
801077b5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801077ba:	e9 ab f5 ff ff       	jmp    80106d6a <alltraps>

801077bf <vector150>:
.globl vector150
vector150:
  pushl $0
801077bf:	6a 00                	push   $0x0
  pushl $150
801077c1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801077c6:	e9 9f f5 ff ff       	jmp    80106d6a <alltraps>

801077cb <vector151>:
.globl vector151
vector151:
  pushl $0
801077cb:	6a 00                	push   $0x0
  pushl $151
801077cd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801077d2:	e9 93 f5 ff ff       	jmp    80106d6a <alltraps>

801077d7 <vector152>:
.globl vector152
vector152:
  pushl $0
801077d7:	6a 00                	push   $0x0
  pushl $152
801077d9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801077de:	e9 87 f5 ff ff       	jmp    80106d6a <alltraps>

801077e3 <vector153>:
.globl vector153
vector153:
  pushl $0
801077e3:	6a 00                	push   $0x0
  pushl $153
801077e5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801077ea:	e9 7b f5 ff ff       	jmp    80106d6a <alltraps>

801077ef <vector154>:
.globl vector154
vector154:
  pushl $0
801077ef:	6a 00                	push   $0x0
  pushl $154
801077f1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801077f6:	e9 6f f5 ff ff       	jmp    80106d6a <alltraps>

801077fb <vector155>:
.globl vector155
vector155:
  pushl $0
801077fb:	6a 00                	push   $0x0
  pushl $155
801077fd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107802:	e9 63 f5 ff ff       	jmp    80106d6a <alltraps>

80107807 <vector156>:
.globl vector156
vector156:
  pushl $0
80107807:	6a 00                	push   $0x0
  pushl $156
80107809:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010780e:	e9 57 f5 ff ff       	jmp    80106d6a <alltraps>

80107813 <vector157>:
.globl vector157
vector157:
  pushl $0
80107813:	6a 00                	push   $0x0
  pushl $157
80107815:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010781a:	e9 4b f5 ff ff       	jmp    80106d6a <alltraps>

8010781f <vector158>:
.globl vector158
vector158:
  pushl $0
8010781f:	6a 00                	push   $0x0
  pushl $158
80107821:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107826:	e9 3f f5 ff ff       	jmp    80106d6a <alltraps>

8010782b <vector159>:
.globl vector159
vector159:
  pushl $0
8010782b:	6a 00                	push   $0x0
  pushl $159
8010782d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107832:	e9 33 f5 ff ff       	jmp    80106d6a <alltraps>

80107837 <vector160>:
.globl vector160
vector160:
  pushl $0
80107837:	6a 00                	push   $0x0
  pushl $160
80107839:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010783e:	e9 27 f5 ff ff       	jmp    80106d6a <alltraps>

80107843 <vector161>:
.globl vector161
vector161:
  pushl $0
80107843:	6a 00                	push   $0x0
  pushl $161
80107845:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010784a:	e9 1b f5 ff ff       	jmp    80106d6a <alltraps>

8010784f <vector162>:
.globl vector162
vector162:
  pushl $0
8010784f:	6a 00                	push   $0x0
  pushl $162
80107851:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107856:	e9 0f f5 ff ff       	jmp    80106d6a <alltraps>

8010785b <vector163>:
.globl vector163
vector163:
  pushl $0
8010785b:	6a 00                	push   $0x0
  pushl $163
8010785d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107862:	e9 03 f5 ff ff       	jmp    80106d6a <alltraps>

80107867 <vector164>:
.globl vector164
vector164:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $164
80107869:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010786e:	e9 f7 f4 ff ff       	jmp    80106d6a <alltraps>

80107873 <vector165>:
.globl vector165
vector165:
  pushl $0
80107873:	6a 00                	push   $0x0
  pushl $165
80107875:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010787a:	e9 eb f4 ff ff       	jmp    80106d6a <alltraps>

8010787f <vector166>:
.globl vector166
vector166:
  pushl $0
8010787f:	6a 00                	push   $0x0
  pushl $166
80107881:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107886:	e9 df f4 ff ff       	jmp    80106d6a <alltraps>

8010788b <vector167>:
.globl vector167
vector167:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $167
8010788d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107892:	e9 d3 f4 ff ff       	jmp    80106d6a <alltraps>

80107897 <vector168>:
.globl vector168
vector168:
  pushl $0
80107897:	6a 00                	push   $0x0
  pushl $168
80107899:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010789e:	e9 c7 f4 ff ff       	jmp    80106d6a <alltraps>

801078a3 <vector169>:
.globl vector169
vector169:
  pushl $0
801078a3:	6a 00                	push   $0x0
  pushl $169
801078a5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801078aa:	e9 bb f4 ff ff       	jmp    80106d6a <alltraps>

801078af <vector170>:
.globl vector170
vector170:
  pushl $0
801078af:	6a 00                	push   $0x0
  pushl $170
801078b1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801078b6:	e9 af f4 ff ff       	jmp    80106d6a <alltraps>

801078bb <vector171>:
.globl vector171
vector171:
  pushl $0
801078bb:	6a 00                	push   $0x0
  pushl $171
801078bd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801078c2:	e9 a3 f4 ff ff       	jmp    80106d6a <alltraps>

801078c7 <vector172>:
.globl vector172
vector172:
  pushl $0
801078c7:	6a 00                	push   $0x0
  pushl $172
801078c9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801078ce:	e9 97 f4 ff ff       	jmp    80106d6a <alltraps>

801078d3 <vector173>:
.globl vector173
vector173:
  pushl $0
801078d3:	6a 00                	push   $0x0
  pushl $173
801078d5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801078da:	e9 8b f4 ff ff       	jmp    80106d6a <alltraps>

801078df <vector174>:
.globl vector174
vector174:
  pushl $0
801078df:	6a 00                	push   $0x0
  pushl $174
801078e1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801078e6:	e9 7f f4 ff ff       	jmp    80106d6a <alltraps>

801078eb <vector175>:
.globl vector175
vector175:
  pushl $0
801078eb:	6a 00                	push   $0x0
  pushl $175
801078ed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801078f2:	e9 73 f4 ff ff       	jmp    80106d6a <alltraps>

801078f7 <vector176>:
.globl vector176
vector176:
  pushl $0
801078f7:	6a 00                	push   $0x0
  pushl $176
801078f9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801078fe:	e9 67 f4 ff ff       	jmp    80106d6a <alltraps>

80107903 <vector177>:
.globl vector177
vector177:
  pushl $0
80107903:	6a 00                	push   $0x0
  pushl $177
80107905:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010790a:	e9 5b f4 ff ff       	jmp    80106d6a <alltraps>

8010790f <vector178>:
.globl vector178
vector178:
  pushl $0
8010790f:	6a 00                	push   $0x0
  pushl $178
80107911:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107916:	e9 4f f4 ff ff       	jmp    80106d6a <alltraps>

8010791b <vector179>:
.globl vector179
vector179:
  pushl $0
8010791b:	6a 00                	push   $0x0
  pushl $179
8010791d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107922:	e9 43 f4 ff ff       	jmp    80106d6a <alltraps>

80107927 <vector180>:
.globl vector180
vector180:
  pushl $0
80107927:	6a 00                	push   $0x0
  pushl $180
80107929:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010792e:	e9 37 f4 ff ff       	jmp    80106d6a <alltraps>

80107933 <vector181>:
.globl vector181
vector181:
  pushl $0
80107933:	6a 00                	push   $0x0
  pushl $181
80107935:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010793a:	e9 2b f4 ff ff       	jmp    80106d6a <alltraps>

8010793f <vector182>:
.globl vector182
vector182:
  pushl $0
8010793f:	6a 00                	push   $0x0
  pushl $182
80107941:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107946:	e9 1f f4 ff ff       	jmp    80106d6a <alltraps>

8010794b <vector183>:
.globl vector183
vector183:
  pushl $0
8010794b:	6a 00                	push   $0x0
  pushl $183
8010794d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107952:	e9 13 f4 ff ff       	jmp    80106d6a <alltraps>

80107957 <vector184>:
.globl vector184
vector184:
  pushl $0
80107957:	6a 00                	push   $0x0
  pushl $184
80107959:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010795e:	e9 07 f4 ff ff       	jmp    80106d6a <alltraps>

80107963 <vector185>:
.globl vector185
vector185:
  pushl $0
80107963:	6a 00                	push   $0x0
  pushl $185
80107965:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010796a:	e9 fb f3 ff ff       	jmp    80106d6a <alltraps>

8010796f <vector186>:
.globl vector186
vector186:
  pushl $0
8010796f:	6a 00                	push   $0x0
  pushl $186
80107971:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107976:	e9 ef f3 ff ff       	jmp    80106d6a <alltraps>

8010797b <vector187>:
.globl vector187
vector187:
  pushl $0
8010797b:	6a 00                	push   $0x0
  pushl $187
8010797d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107982:	e9 e3 f3 ff ff       	jmp    80106d6a <alltraps>

80107987 <vector188>:
.globl vector188
vector188:
  pushl $0
80107987:	6a 00                	push   $0x0
  pushl $188
80107989:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010798e:	e9 d7 f3 ff ff       	jmp    80106d6a <alltraps>

80107993 <vector189>:
.globl vector189
vector189:
  pushl $0
80107993:	6a 00                	push   $0x0
  pushl $189
80107995:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010799a:	e9 cb f3 ff ff       	jmp    80106d6a <alltraps>

8010799f <vector190>:
.globl vector190
vector190:
  pushl $0
8010799f:	6a 00                	push   $0x0
  pushl $190
801079a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801079a6:	e9 bf f3 ff ff       	jmp    80106d6a <alltraps>

801079ab <vector191>:
.globl vector191
vector191:
  pushl $0
801079ab:	6a 00                	push   $0x0
  pushl $191
801079ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801079b2:	e9 b3 f3 ff ff       	jmp    80106d6a <alltraps>

801079b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801079b7:	6a 00                	push   $0x0
  pushl $192
801079b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801079be:	e9 a7 f3 ff ff       	jmp    80106d6a <alltraps>

801079c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801079c3:	6a 00                	push   $0x0
  pushl $193
801079c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801079ca:	e9 9b f3 ff ff       	jmp    80106d6a <alltraps>

801079cf <vector194>:
.globl vector194
vector194:
  pushl $0
801079cf:	6a 00                	push   $0x0
  pushl $194
801079d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801079d6:	e9 8f f3 ff ff       	jmp    80106d6a <alltraps>

801079db <vector195>:
.globl vector195
vector195:
  pushl $0
801079db:	6a 00                	push   $0x0
  pushl $195
801079dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801079e2:	e9 83 f3 ff ff       	jmp    80106d6a <alltraps>

801079e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801079e7:	6a 00                	push   $0x0
  pushl $196
801079e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801079ee:	e9 77 f3 ff ff       	jmp    80106d6a <alltraps>

801079f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801079f3:	6a 00                	push   $0x0
  pushl $197
801079f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801079fa:	e9 6b f3 ff ff       	jmp    80106d6a <alltraps>

801079ff <vector198>:
.globl vector198
vector198:
  pushl $0
801079ff:	6a 00                	push   $0x0
  pushl $198
80107a01:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107a06:	e9 5f f3 ff ff       	jmp    80106d6a <alltraps>

80107a0b <vector199>:
.globl vector199
vector199:
  pushl $0
80107a0b:	6a 00                	push   $0x0
  pushl $199
80107a0d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107a12:	e9 53 f3 ff ff       	jmp    80106d6a <alltraps>

80107a17 <vector200>:
.globl vector200
vector200:
  pushl $0
80107a17:	6a 00                	push   $0x0
  pushl $200
80107a19:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107a1e:	e9 47 f3 ff ff       	jmp    80106d6a <alltraps>

80107a23 <vector201>:
.globl vector201
vector201:
  pushl $0
80107a23:	6a 00                	push   $0x0
  pushl $201
80107a25:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107a2a:	e9 3b f3 ff ff       	jmp    80106d6a <alltraps>

80107a2f <vector202>:
.globl vector202
vector202:
  pushl $0
80107a2f:	6a 00                	push   $0x0
  pushl $202
80107a31:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107a36:	e9 2f f3 ff ff       	jmp    80106d6a <alltraps>

80107a3b <vector203>:
.globl vector203
vector203:
  pushl $0
80107a3b:	6a 00                	push   $0x0
  pushl $203
80107a3d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107a42:	e9 23 f3 ff ff       	jmp    80106d6a <alltraps>

80107a47 <vector204>:
.globl vector204
vector204:
  pushl $0
80107a47:	6a 00                	push   $0x0
  pushl $204
80107a49:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107a4e:	e9 17 f3 ff ff       	jmp    80106d6a <alltraps>

80107a53 <vector205>:
.globl vector205
vector205:
  pushl $0
80107a53:	6a 00                	push   $0x0
  pushl $205
80107a55:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107a5a:	e9 0b f3 ff ff       	jmp    80106d6a <alltraps>

80107a5f <vector206>:
.globl vector206
vector206:
  pushl $0
80107a5f:	6a 00                	push   $0x0
  pushl $206
80107a61:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107a66:	e9 ff f2 ff ff       	jmp    80106d6a <alltraps>

80107a6b <vector207>:
.globl vector207
vector207:
  pushl $0
80107a6b:	6a 00                	push   $0x0
  pushl $207
80107a6d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107a72:	e9 f3 f2 ff ff       	jmp    80106d6a <alltraps>

80107a77 <vector208>:
.globl vector208
vector208:
  pushl $0
80107a77:	6a 00                	push   $0x0
  pushl $208
80107a79:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107a7e:	e9 e7 f2 ff ff       	jmp    80106d6a <alltraps>

80107a83 <vector209>:
.globl vector209
vector209:
  pushl $0
80107a83:	6a 00                	push   $0x0
  pushl $209
80107a85:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107a8a:	e9 db f2 ff ff       	jmp    80106d6a <alltraps>

80107a8f <vector210>:
.globl vector210
vector210:
  pushl $0
80107a8f:	6a 00                	push   $0x0
  pushl $210
80107a91:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107a96:	e9 cf f2 ff ff       	jmp    80106d6a <alltraps>

80107a9b <vector211>:
.globl vector211
vector211:
  pushl $0
80107a9b:	6a 00                	push   $0x0
  pushl $211
80107a9d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107aa2:	e9 c3 f2 ff ff       	jmp    80106d6a <alltraps>

80107aa7 <vector212>:
.globl vector212
vector212:
  pushl $0
80107aa7:	6a 00                	push   $0x0
  pushl $212
80107aa9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107aae:	e9 b7 f2 ff ff       	jmp    80106d6a <alltraps>

80107ab3 <vector213>:
.globl vector213
vector213:
  pushl $0
80107ab3:	6a 00                	push   $0x0
  pushl $213
80107ab5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107aba:	e9 ab f2 ff ff       	jmp    80106d6a <alltraps>

80107abf <vector214>:
.globl vector214
vector214:
  pushl $0
80107abf:	6a 00                	push   $0x0
  pushl $214
80107ac1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107ac6:	e9 9f f2 ff ff       	jmp    80106d6a <alltraps>

80107acb <vector215>:
.globl vector215
vector215:
  pushl $0
80107acb:	6a 00                	push   $0x0
  pushl $215
80107acd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107ad2:	e9 93 f2 ff ff       	jmp    80106d6a <alltraps>

80107ad7 <vector216>:
.globl vector216
vector216:
  pushl $0
80107ad7:	6a 00                	push   $0x0
  pushl $216
80107ad9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107ade:	e9 87 f2 ff ff       	jmp    80106d6a <alltraps>

80107ae3 <vector217>:
.globl vector217
vector217:
  pushl $0
80107ae3:	6a 00                	push   $0x0
  pushl $217
80107ae5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107aea:	e9 7b f2 ff ff       	jmp    80106d6a <alltraps>

80107aef <vector218>:
.globl vector218
vector218:
  pushl $0
80107aef:	6a 00                	push   $0x0
  pushl $218
80107af1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107af6:	e9 6f f2 ff ff       	jmp    80106d6a <alltraps>

80107afb <vector219>:
.globl vector219
vector219:
  pushl $0
80107afb:	6a 00                	push   $0x0
  pushl $219
80107afd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107b02:	e9 63 f2 ff ff       	jmp    80106d6a <alltraps>

80107b07 <vector220>:
.globl vector220
vector220:
  pushl $0
80107b07:	6a 00                	push   $0x0
  pushl $220
80107b09:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107b0e:	e9 57 f2 ff ff       	jmp    80106d6a <alltraps>

80107b13 <vector221>:
.globl vector221
vector221:
  pushl $0
80107b13:	6a 00                	push   $0x0
  pushl $221
80107b15:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107b1a:	e9 4b f2 ff ff       	jmp    80106d6a <alltraps>

80107b1f <vector222>:
.globl vector222
vector222:
  pushl $0
80107b1f:	6a 00                	push   $0x0
  pushl $222
80107b21:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107b26:	e9 3f f2 ff ff       	jmp    80106d6a <alltraps>

80107b2b <vector223>:
.globl vector223
vector223:
  pushl $0
80107b2b:	6a 00                	push   $0x0
  pushl $223
80107b2d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107b32:	e9 33 f2 ff ff       	jmp    80106d6a <alltraps>

80107b37 <vector224>:
.globl vector224
vector224:
  pushl $0
80107b37:	6a 00                	push   $0x0
  pushl $224
80107b39:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107b3e:	e9 27 f2 ff ff       	jmp    80106d6a <alltraps>

80107b43 <vector225>:
.globl vector225
vector225:
  pushl $0
80107b43:	6a 00                	push   $0x0
  pushl $225
80107b45:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107b4a:	e9 1b f2 ff ff       	jmp    80106d6a <alltraps>

80107b4f <vector226>:
.globl vector226
vector226:
  pushl $0
80107b4f:	6a 00                	push   $0x0
  pushl $226
80107b51:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107b56:	e9 0f f2 ff ff       	jmp    80106d6a <alltraps>

80107b5b <vector227>:
.globl vector227
vector227:
  pushl $0
80107b5b:	6a 00                	push   $0x0
  pushl $227
80107b5d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107b62:	e9 03 f2 ff ff       	jmp    80106d6a <alltraps>

80107b67 <vector228>:
.globl vector228
vector228:
  pushl $0
80107b67:	6a 00                	push   $0x0
  pushl $228
80107b69:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107b6e:	e9 f7 f1 ff ff       	jmp    80106d6a <alltraps>

80107b73 <vector229>:
.globl vector229
vector229:
  pushl $0
80107b73:	6a 00                	push   $0x0
  pushl $229
80107b75:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107b7a:	e9 eb f1 ff ff       	jmp    80106d6a <alltraps>

80107b7f <vector230>:
.globl vector230
vector230:
  pushl $0
80107b7f:	6a 00                	push   $0x0
  pushl $230
80107b81:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107b86:	e9 df f1 ff ff       	jmp    80106d6a <alltraps>

80107b8b <vector231>:
.globl vector231
vector231:
  pushl $0
80107b8b:	6a 00                	push   $0x0
  pushl $231
80107b8d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107b92:	e9 d3 f1 ff ff       	jmp    80106d6a <alltraps>

80107b97 <vector232>:
.globl vector232
vector232:
  pushl $0
80107b97:	6a 00                	push   $0x0
  pushl $232
80107b99:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107b9e:	e9 c7 f1 ff ff       	jmp    80106d6a <alltraps>

80107ba3 <vector233>:
.globl vector233
vector233:
  pushl $0
80107ba3:	6a 00                	push   $0x0
  pushl $233
80107ba5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107baa:	e9 bb f1 ff ff       	jmp    80106d6a <alltraps>

80107baf <vector234>:
.globl vector234
vector234:
  pushl $0
80107baf:	6a 00                	push   $0x0
  pushl $234
80107bb1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107bb6:	e9 af f1 ff ff       	jmp    80106d6a <alltraps>

80107bbb <vector235>:
.globl vector235
vector235:
  pushl $0
80107bbb:	6a 00                	push   $0x0
  pushl $235
80107bbd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107bc2:	e9 a3 f1 ff ff       	jmp    80106d6a <alltraps>

80107bc7 <vector236>:
.globl vector236
vector236:
  pushl $0
80107bc7:	6a 00                	push   $0x0
  pushl $236
80107bc9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107bce:	e9 97 f1 ff ff       	jmp    80106d6a <alltraps>

80107bd3 <vector237>:
.globl vector237
vector237:
  pushl $0
80107bd3:	6a 00                	push   $0x0
  pushl $237
80107bd5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107bda:	e9 8b f1 ff ff       	jmp    80106d6a <alltraps>

80107bdf <vector238>:
.globl vector238
vector238:
  pushl $0
80107bdf:	6a 00                	push   $0x0
  pushl $238
80107be1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107be6:	e9 7f f1 ff ff       	jmp    80106d6a <alltraps>

80107beb <vector239>:
.globl vector239
vector239:
  pushl $0
80107beb:	6a 00                	push   $0x0
  pushl $239
80107bed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107bf2:	e9 73 f1 ff ff       	jmp    80106d6a <alltraps>

80107bf7 <vector240>:
.globl vector240
vector240:
  pushl $0
80107bf7:	6a 00                	push   $0x0
  pushl $240
80107bf9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107bfe:	e9 67 f1 ff ff       	jmp    80106d6a <alltraps>

80107c03 <vector241>:
.globl vector241
vector241:
  pushl $0
80107c03:	6a 00                	push   $0x0
  pushl $241
80107c05:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107c0a:	e9 5b f1 ff ff       	jmp    80106d6a <alltraps>

80107c0f <vector242>:
.globl vector242
vector242:
  pushl $0
80107c0f:	6a 00                	push   $0x0
  pushl $242
80107c11:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107c16:	e9 4f f1 ff ff       	jmp    80106d6a <alltraps>

80107c1b <vector243>:
.globl vector243
vector243:
  pushl $0
80107c1b:	6a 00                	push   $0x0
  pushl $243
80107c1d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107c22:	e9 43 f1 ff ff       	jmp    80106d6a <alltraps>

80107c27 <vector244>:
.globl vector244
vector244:
  pushl $0
80107c27:	6a 00                	push   $0x0
  pushl $244
80107c29:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107c2e:	e9 37 f1 ff ff       	jmp    80106d6a <alltraps>

80107c33 <vector245>:
.globl vector245
vector245:
  pushl $0
80107c33:	6a 00                	push   $0x0
  pushl $245
80107c35:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107c3a:	e9 2b f1 ff ff       	jmp    80106d6a <alltraps>

80107c3f <vector246>:
.globl vector246
vector246:
  pushl $0
80107c3f:	6a 00                	push   $0x0
  pushl $246
80107c41:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107c46:	e9 1f f1 ff ff       	jmp    80106d6a <alltraps>

80107c4b <vector247>:
.globl vector247
vector247:
  pushl $0
80107c4b:	6a 00                	push   $0x0
  pushl $247
80107c4d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107c52:	e9 13 f1 ff ff       	jmp    80106d6a <alltraps>

80107c57 <vector248>:
.globl vector248
vector248:
  pushl $0
80107c57:	6a 00                	push   $0x0
  pushl $248
80107c59:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107c5e:	e9 07 f1 ff ff       	jmp    80106d6a <alltraps>

80107c63 <vector249>:
.globl vector249
vector249:
  pushl $0
80107c63:	6a 00                	push   $0x0
  pushl $249
80107c65:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107c6a:	e9 fb f0 ff ff       	jmp    80106d6a <alltraps>

80107c6f <vector250>:
.globl vector250
vector250:
  pushl $0
80107c6f:	6a 00                	push   $0x0
  pushl $250
80107c71:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107c76:	e9 ef f0 ff ff       	jmp    80106d6a <alltraps>

80107c7b <vector251>:
.globl vector251
vector251:
  pushl $0
80107c7b:	6a 00                	push   $0x0
  pushl $251
80107c7d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107c82:	e9 e3 f0 ff ff       	jmp    80106d6a <alltraps>

80107c87 <vector252>:
.globl vector252
vector252:
  pushl $0
80107c87:	6a 00                	push   $0x0
  pushl $252
80107c89:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107c8e:	e9 d7 f0 ff ff       	jmp    80106d6a <alltraps>

80107c93 <vector253>:
.globl vector253
vector253:
  pushl $0
80107c93:	6a 00                	push   $0x0
  pushl $253
80107c95:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107c9a:	e9 cb f0 ff ff       	jmp    80106d6a <alltraps>

80107c9f <vector254>:
.globl vector254
vector254:
  pushl $0
80107c9f:	6a 00                	push   $0x0
  pushl $254
80107ca1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107ca6:	e9 bf f0 ff ff       	jmp    80106d6a <alltraps>

80107cab <vector255>:
.globl vector255
vector255:
  pushl $0
80107cab:	6a 00                	push   $0x0
  pushl $255
80107cad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107cb2:	e9 b3 f0 ff ff       	jmp    80106d6a <alltraps>
80107cb7:	66 90                	xchg   %ax,%ax
80107cb9:	66 90                	xchg   %ax,%ax
80107cbb:	66 90                	xchg   %ax,%ax
80107cbd:	66 90                	xchg   %ax,%ax
80107cbf:	90                   	nop

80107cc0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107cc0:	55                   	push   %ebp
80107cc1:	89 e5                	mov    %esp,%ebp
80107cc3:	57                   	push   %edi
80107cc4:	56                   	push   %esi
80107cc5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107cc6:	89 d3                	mov    %edx,%ebx
{
80107cc8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80107cca:	c1 eb 16             	shr    $0x16,%ebx
80107ccd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107cd0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107cd3:	8b 06                	mov    (%esi),%eax
80107cd5:	a8 01                	test   $0x1,%al
80107cd7:	74 27                	je     80107d00 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107cd9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cde:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107ce4:	c1 ef 0a             	shr    $0xa,%edi
}
80107ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107cea:	89 fa                	mov    %edi,%edx
80107cec:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107cf2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107cf5:	5b                   	pop    %ebx
80107cf6:	5e                   	pop    %esi
80107cf7:	5f                   	pop    %edi
80107cf8:	5d                   	pop    %ebp
80107cf9:	c3                   	ret    
80107cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107d00:	85 c9                	test   %ecx,%ecx
80107d02:	74 2c                	je     80107d30 <walkpgdir+0x70>
80107d04:	e8 57 ab ff ff       	call   80102860 <kalloc>
80107d09:	85 c0                	test   %eax,%eax
80107d0b:	89 c3                	mov    %eax,%ebx
80107d0d:	74 21                	je     80107d30 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80107d0f:	83 ec 04             	sub    $0x4,%esp
80107d12:	68 00 10 00 00       	push   $0x1000
80107d17:	6a 00                	push   $0x0
80107d19:	50                   	push   %eax
80107d1a:	e8 51 de ff ff       	call   80105b70 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107d1f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107d25:	83 c4 10             	add    $0x10,%esp
80107d28:	83 c8 07             	or     $0x7,%eax
80107d2b:	89 06                	mov    %eax,(%esi)
80107d2d:	eb b5                	jmp    80107ce4 <walkpgdir+0x24>
80107d2f:	90                   	nop
}
80107d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107d33:	31 c0                	xor    %eax,%eax
}
80107d35:	5b                   	pop    %ebx
80107d36:	5e                   	pop    %esi
80107d37:	5f                   	pop    %edi
80107d38:	5d                   	pop    %ebp
80107d39:	c3                   	ret    
80107d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107d40 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107d40:	55                   	push   %ebp
80107d41:	89 e5                	mov    %esp,%ebp
80107d43:	57                   	push   %edi
80107d44:	56                   	push   %esi
80107d45:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107d46:	89 d3                	mov    %edx,%ebx
80107d48:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80107d4e:	83 ec 1c             	sub    $0x1c,%esp
80107d51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107d54:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107d58:	8b 7d 08             	mov    0x8(%ebp),%edi
80107d5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d60:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107d63:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d66:	29 df                	sub    %ebx,%edi
80107d68:	83 c8 01             	or     $0x1,%eax
80107d6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107d6e:	eb 15                	jmp    80107d85 <mappages+0x45>
    if(*pte & PTE_P)
80107d70:	f6 00 01             	testb  $0x1,(%eax)
80107d73:	75 45                	jne    80107dba <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107d75:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107d78:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80107d7b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80107d7d:	74 31                	je     80107db0 <mappages+0x70>
      break;
    a += PGSIZE;
80107d7f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d88:	b9 01 00 00 00       	mov    $0x1,%ecx
80107d8d:	89 da                	mov    %ebx,%edx
80107d8f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107d92:	e8 29 ff ff ff       	call   80107cc0 <walkpgdir>
80107d97:	85 c0                	test   %eax,%eax
80107d99:	75 d5                	jne    80107d70 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107d9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107d9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107da3:	5b                   	pop    %ebx
80107da4:	5e                   	pop    %esi
80107da5:	5f                   	pop    %edi
80107da6:	5d                   	pop    %ebp
80107da7:	c3                   	ret    
80107da8:	90                   	nop
80107da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107db3:	31 c0                	xor    %eax,%eax
}
80107db5:	5b                   	pop    %ebx
80107db6:	5e                   	pop    %esi
80107db7:	5f                   	pop    %edi
80107db8:	5d                   	pop    %ebp
80107db9:	c3                   	ret    
      panic("remap");
80107dba:	83 ec 0c             	sub    $0xc,%esp
80107dbd:	68 24 91 10 80       	push   $0x80109124
80107dc2:	e8 c9 85 ff ff       	call   80100390 <panic>
80107dc7:	89 f6                	mov    %esi,%esi
80107dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107dd0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107dd0:	55                   	push   %ebp
80107dd1:	89 e5                	mov    %esp,%ebp
80107dd3:	57                   	push   %edi
80107dd4:	56                   	push   %esi
80107dd5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107dd6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107ddc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80107dde:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107de4:	83 ec 1c             	sub    $0x1c,%esp
80107de7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107dea:	39 d3                	cmp    %edx,%ebx
80107dec:	73 66                	jae    80107e54 <deallocuvm.part.0+0x84>
80107dee:	89 d6                	mov    %edx,%esi
80107df0:	eb 3d                	jmp    80107e2f <deallocuvm.part.0+0x5f>
80107df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107df8:	8b 10                	mov    (%eax),%edx
80107dfa:	f6 c2 01             	test   $0x1,%dl
80107dfd:	74 26                	je     80107e25 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107dff:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107e05:	74 58                	je     80107e5f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107e07:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107e0a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107e10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107e13:	52                   	push   %edx
80107e14:	e8 97 a8 ff ff       	call   801026b0 <kfree>
      *pte = 0;
80107e19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e1c:	83 c4 10             	add    $0x10,%esp
80107e1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107e25:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107e2b:	39 f3                	cmp    %esi,%ebx
80107e2d:	73 25                	jae    80107e54 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107e2f:	31 c9                	xor    %ecx,%ecx
80107e31:	89 da                	mov    %ebx,%edx
80107e33:	89 f8                	mov    %edi,%eax
80107e35:	e8 86 fe ff ff       	call   80107cc0 <walkpgdir>
    if(!pte)
80107e3a:	85 c0                	test   %eax,%eax
80107e3c:	75 ba                	jne    80107df8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107e3e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107e44:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107e4a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107e50:	39 f3                	cmp    %esi,%ebx
80107e52:	72 db                	jb     80107e2f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107e54:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e5a:	5b                   	pop    %ebx
80107e5b:	5e                   	pop    %esi
80107e5c:	5f                   	pop    %edi
80107e5d:	5d                   	pop    %ebp
80107e5e:	c3                   	ret    
        panic("kfree");
80107e5f:	83 ec 0c             	sub    $0xc,%esp
80107e62:	68 66 88 10 80       	push   $0x80108866
80107e67:	e8 24 85 ff ff       	call   80100390 <panic>
80107e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107e70 <seginit>:
{
80107e70:	55                   	push   %ebp
80107e71:	89 e5                	mov    %esp,%ebp
80107e73:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107e76:	e8 f5 bc ff ff       	call   80103b70 <cpuid>
80107e7b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107e81:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107e86:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107e8a:	c7 80 58 4d 11 80 ff 	movl   $0xffff,-0x7feeb2a8(%eax)
80107e91:	ff 00 00 
80107e94:	c7 80 5c 4d 11 80 00 	movl   $0xcf9a00,-0x7feeb2a4(%eax)
80107e9b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107e9e:	c7 80 60 4d 11 80 ff 	movl   $0xffff,-0x7feeb2a0(%eax)
80107ea5:	ff 00 00 
80107ea8:	c7 80 64 4d 11 80 00 	movl   $0xcf9200,-0x7feeb29c(%eax)
80107eaf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107eb2:	c7 80 68 4d 11 80 ff 	movl   $0xffff,-0x7feeb298(%eax)
80107eb9:	ff 00 00 
80107ebc:	c7 80 6c 4d 11 80 00 	movl   $0xcffa00,-0x7feeb294(%eax)
80107ec3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107ec6:	c7 80 70 4d 11 80 ff 	movl   $0xffff,-0x7feeb290(%eax)
80107ecd:	ff 00 00 
80107ed0:	c7 80 74 4d 11 80 00 	movl   $0xcff200,-0x7feeb28c(%eax)
80107ed7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107eda:	05 50 4d 11 80       	add    $0x80114d50,%eax
  pd[1] = (uint)p;
80107edf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107ee3:	c1 e8 10             	shr    $0x10,%eax
80107ee6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107eea:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107eed:	0f 01 10             	lgdtl  (%eax)
}
80107ef0:	c9                   	leave  
80107ef1:	c3                   	ret    
80107ef2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107f00 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107f00:	a1 44 85 11 80       	mov    0x80118544,%eax
{
80107f05:	55                   	push   %ebp
80107f06:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107f08:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f0d:	0f 22 d8             	mov    %eax,%cr3
}
80107f10:	5d                   	pop    %ebp
80107f11:	c3                   	ret    
80107f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107f20 <switchuvm>:
{
80107f20:	55                   	push   %ebp
80107f21:	89 e5                	mov    %esp,%ebp
80107f23:	57                   	push   %edi
80107f24:	56                   	push   %esi
80107f25:	53                   	push   %ebx
80107f26:	83 ec 1c             	sub    $0x1c,%esp
80107f29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80107f2c:	85 db                	test   %ebx,%ebx
80107f2e:	0f 84 cb 00 00 00    	je     80107fff <switchuvm+0xdf>
  if(p->kstack == 0)
80107f34:	8b 43 08             	mov    0x8(%ebx),%eax
80107f37:	85 c0                	test   %eax,%eax
80107f39:	0f 84 da 00 00 00    	je     80108019 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107f3f:	8b 43 04             	mov    0x4(%ebx),%eax
80107f42:	85 c0                	test   %eax,%eax
80107f44:	0f 84 c2 00 00 00    	je     8010800c <switchuvm+0xec>
  pushcli();
80107f4a:	e8 41 da ff ff       	call   80105990 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107f4f:	e8 9c bb ff ff       	call   80103af0 <mycpu>
80107f54:	89 c6                	mov    %eax,%esi
80107f56:	e8 95 bb ff ff       	call   80103af0 <mycpu>
80107f5b:	89 c7                	mov    %eax,%edi
80107f5d:	e8 8e bb ff ff       	call   80103af0 <mycpu>
80107f62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107f65:	83 c7 08             	add    $0x8,%edi
80107f68:	e8 83 bb ff ff       	call   80103af0 <mycpu>
80107f6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107f70:	83 c0 08             	add    $0x8,%eax
80107f73:	ba 67 00 00 00       	mov    $0x67,%edx
80107f78:	c1 e8 18             	shr    $0x18,%eax
80107f7b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107f82:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107f89:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107f8f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107f94:	83 c1 08             	add    $0x8,%ecx
80107f97:	c1 e9 10             	shr    $0x10,%ecx
80107f9a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107fa0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107fa5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107fac:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107fb1:	e8 3a bb ff ff       	call   80103af0 <mycpu>
80107fb6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107fbd:	e8 2e bb ff ff       	call   80103af0 <mycpu>
80107fc2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107fc6:	8b 73 08             	mov    0x8(%ebx),%esi
80107fc9:	e8 22 bb ff ff       	call   80103af0 <mycpu>
80107fce:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107fd4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107fd7:	e8 14 bb ff ff       	call   80103af0 <mycpu>
80107fdc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107fe0:	b8 28 00 00 00       	mov    $0x28,%eax
80107fe5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107fe8:	8b 43 04             	mov    0x4(%ebx),%eax
80107feb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107ff0:	0f 22 d8             	mov    %eax,%cr3
}
80107ff3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ff6:	5b                   	pop    %ebx
80107ff7:	5e                   	pop    %esi
80107ff8:	5f                   	pop    %edi
80107ff9:	5d                   	pop    %ebp
  popcli();
80107ffa:	e9 d1 d9 ff ff       	jmp    801059d0 <popcli>
    panic("switchuvm: no process");
80107fff:	83 ec 0c             	sub    $0xc,%esp
80108002:	68 2a 91 10 80       	push   $0x8010912a
80108007:	e8 84 83 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010800c:	83 ec 0c             	sub    $0xc,%esp
8010800f:	68 55 91 10 80       	push   $0x80109155
80108014:	e8 77 83 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80108019:	83 ec 0c             	sub    $0xc,%esp
8010801c:	68 40 91 10 80       	push   $0x80109140
80108021:	e8 6a 83 ff ff       	call   80100390 <panic>
80108026:	8d 76 00             	lea    0x0(%esi),%esi
80108029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108030 <inituvm>:
{
80108030:	55                   	push   %ebp
80108031:	89 e5                	mov    %esp,%ebp
80108033:	57                   	push   %edi
80108034:	56                   	push   %esi
80108035:	53                   	push   %ebx
80108036:	83 ec 1c             	sub    $0x1c,%esp
80108039:	8b 75 10             	mov    0x10(%ebp),%esi
8010803c:	8b 45 08             	mov    0x8(%ebp),%eax
8010803f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80108042:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80108048:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010804b:	77 49                	ja     80108096 <inituvm+0x66>
  mem = kalloc();
8010804d:	e8 0e a8 ff ff       	call   80102860 <kalloc>
  memset(mem, 0, PGSIZE);
80108052:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80108055:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80108057:	68 00 10 00 00       	push   $0x1000
8010805c:	6a 00                	push   $0x0
8010805e:	50                   	push   %eax
8010805f:	e8 0c db ff ff       	call   80105b70 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108064:	58                   	pop    %eax
80108065:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010806b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108070:	5a                   	pop    %edx
80108071:	6a 06                	push   $0x6
80108073:	50                   	push   %eax
80108074:	31 d2                	xor    %edx,%edx
80108076:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108079:	e8 c2 fc ff ff       	call   80107d40 <mappages>
  memmove(mem, init, sz);
8010807e:	89 75 10             	mov    %esi,0x10(%ebp)
80108081:	89 7d 0c             	mov    %edi,0xc(%ebp)
80108084:	83 c4 10             	add    $0x10,%esp
80108087:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010808a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010808d:	5b                   	pop    %ebx
8010808e:	5e                   	pop    %esi
8010808f:	5f                   	pop    %edi
80108090:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80108091:	e9 8a db ff ff       	jmp    80105c20 <memmove>
    panic("inituvm: more than a page");
80108096:	83 ec 0c             	sub    $0xc,%esp
80108099:	68 69 91 10 80       	push   $0x80109169
8010809e:	e8 ed 82 ff ff       	call   80100390 <panic>
801080a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801080a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801080b0 <loaduvm>:
{
801080b0:	55                   	push   %ebp
801080b1:	89 e5                	mov    %esp,%ebp
801080b3:	57                   	push   %edi
801080b4:	56                   	push   %esi
801080b5:	53                   	push   %ebx
801080b6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801080b9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801080c0:	0f 85 91 00 00 00    	jne    80108157 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
801080c6:	8b 75 18             	mov    0x18(%ebp),%esi
801080c9:	31 db                	xor    %ebx,%ebx
801080cb:	85 f6                	test   %esi,%esi
801080cd:	75 1a                	jne    801080e9 <loaduvm+0x39>
801080cf:	eb 6f                	jmp    80108140 <loaduvm+0x90>
801080d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801080d8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801080de:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801080e4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801080e7:	76 57                	jbe    80108140 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801080e9:	8b 55 0c             	mov    0xc(%ebp),%edx
801080ec:	8b 45 08             	mov    0x8(%ebp),%eax
801080ef:	31 c9                	xor    %ecx,%ecx
801080f1:	01 da                	add    %ebx,%edx
801080f3:	e8 c8 fb ff ff       	call   80107cc0 <walkpgdir>
801080f8:	85 c0                	test   %eax,%eax
801080fa:	74 4e                	je     8010814a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801080fc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801080fe:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80108101:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80108106:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010810b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80108111:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108114:	01 d9                	add    %ebx,%ecx
80108116:	05 00 00 00 80       	add    $0x80000000,%eax
8010811b:	57                   	push   %edi
8010811c:	51                   	push   %ecx
8010811d:	50                   	push   %eax
8010811e:	ff 75 10             	pushl  0x10(%ebp)
80108121:	e8 ea 99 ff ff       	call   80101b10 <readi>
80108126:	83 c4 10             	add    $0x10,%esp
80108129:	39 f8                	cmp    %edi,%eax
8010812b:	74 ab                	je     801080d8 <loaduvm+0x28>
}
8010812d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108135:	5b                   	pop    %ebx
80108136:	5e                   	pop    %esi
80108137:	5f                   	pop    %edi
80108138:	5d                   	pop    %ebp
80108139:	c3                   	ret    
8010813a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108140:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108143:	31 c0                	xor    %eax,%eax
}
80108145:	5b                   	pop    %ebx
80108146:	5e                   	pop    %esi
80108147:	5f                   	pop    %edi
80108148:	5d                   	pop    %ebp
80108149:	c3                   	ret    
      panic("loaduvm: address should exist");
8010814a:	83 ec 0c             	sub    $0xc,%esp
8010814d:	68 83 91 10 80       	push   $0x80109183
80108152:	e8 39 82 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80108157:	83 ec 0c             	sub    $0xc,%esp
8010815a:	68 24 92 10 80       	push   $0x80109224
8010815f:	e8 2c 82 ff ff       	call   80100390 <panic>
80108164:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010816a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108170 <allocuvm>:
{
80108170:	55                   	push   %ebp
80108171:	89 e5                	mov    %esp,%ebp
80108173:	57                   	push   %edi
80108174:	56                   	push   %esi
80108175:	53                   	push   %ebx
80108176:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80108179:	8b 7d 10             	mov    0x10(%ebp),%edi
8010817c:	85 ff                	test   %edi,%edi
8010817e:	0f 88 8e 00 00 00    	js     80108212 <allocuvm+0xa2>
  if(newsz < oldsz)
80108184:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80108187:	0f 82 93 00 00 00    	jb     80108220 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010818d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108190:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80108196:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010819c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010819f:	0f 86 7e 00 00 00    	jbe    80108223 <allocuvm+0xb3>
801081a5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801081a8:	8b 7d 08             	mov    0x8(%ebp),%edi
801081ab:	eb 42                	jmp    801081ef <allocuvm+0x7f>
801081ad:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801081b0:	83 ec 04             	sub    $0x4,%esp
801081b3:	68 00 10 00 00       	push   $0x1000
801081b8:	6a 00                	push   $0x0
801081ba:	50                   	push   %eax
801081bb:	e8 b0 d9 ff ff       	call   80105b70 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801081c0:	58                   	pop    %eax
801081c1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801081c7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801081cc:	5a                   	pop    %edx
801081cd:	6a 06                	push   $0x6
801081cf:	50                   	push   %eax
801081d0:	89 da                	mov    %ebx,%edx
801081d2:	89 f8                	mov    %edi,%eax
801081d4:	e8 67 fb ff ff       	call   80107d40 <mappages>
801081d9:	83 c4 10             	add    $0x10,%esp
801081dc:	85 c0                	test   %eax,%eax
801081de:	78 50                	js     80108230 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801081e0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801081e6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801081e9:	0f 86 81 00 00 00    	jbe    80108270 <allocuvm+0x100>
    mem = kalloc();
801081ef:	e8 6c a6 ff ff       	call   80102860 <kalloc>
    if(mem == 0){
801081f4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801081f6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801081f8:	75 b6                	jne    801081b0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801081fa:	83 ec 0c             	sub    $0xc,%esp
801081fd:	68 a1 91 10 80       	push   $0x801091a1
80108202:	e8 59 84 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80108207:	83 c4 10             	add    $0x10,%esp
8010820a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010820d:	39 45 10             	cmp    %eax,0x10(%ebp)
80108210:	77 6e                	ja     80108280 <allocuvm+0x110>
}
80108212:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80108215:	31 ff                	xor    %edi,%edi
}
80108217:	89 f8                	mov    %edi,%eax
80108219:	5b                   	pop    %ebx
8010821a:	5e                   	pop    %esi
8010821b:	5f                   	pop    %edi
8010821c:	5d                   	pop    %ebp
8010821d:	c3                   	ret    
8010821e:	66 90                	xchg   %ax,%ax
    return oldsz;
80108220:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80108223:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108226:	89 f8                	mov    %edi,%eax
80108228:	5b                   	pop    %ebx
80108229:	5e                   	pop    %esi
8010822a:	5f                   	pop    %edi
8010822b:	5d                   	pop    %ebp
8010822c:	c3                   	ret    
8010822d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108230:	83 ec 0c             	sub    $0xc,%esp
80108233:	68 b9 91 10 80       	push   $0x801091b9
80108238:	e8 23 84 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010823d:	83 c4 10             	add    $0x10,%esp
80108240:	8b 45 0c             	mov    0xc(%ebp),%eax
80108243:	39 45 10             	cmp    %eax,0x10(%ebp)
80108246:	76 0d                	jbe    80108255 <allocuvm+0xe5>
80108248:	89 c1                	mov    %eax,%ecx
8010824a:	8b 55 10             	mov    0x10(%ebp),%edx
8010824d:	8b 45 08             	mov    0x8(%ebp),%eax
80108250:	e8 7b fb ff ff       	call   80107dd0 <deallocuvm.part.0>
      kfree(mem);
80108255:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80108258:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010825a:	56                   	push   %esi
8010825b:	e8 50 a4 ff ff       	call   801026b0 <kfree>
      return 0;
80108260:	83 c4 10             	add    $0x10,%esp
}
80108263:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108266:	89 f8                	mov    %edi,%eax
80108268:	5b                   	pop    %ebx
80108269:	5e                   	pop    %esi
8010826a:	5f                   	pop    %edi
8010826b:	5d                   	pop    %ebp
8010826c:	c3                   	ret    
8010826d:	8d 76 00             	lea    0x0(%esi),%esi
80108270:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80108273:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108276:	5b                   	pop    %ebx
80108277:	89 f8                	mov    %edi,%eax
80108279:	5e                   	pop    %esi
8010827a:	5f                   	pop    %edi
8010827b:	5d                   	pop    %ebp
8010827c:	c3                   	ret    
8010827d:	8d 76 00             	lea    0x0(%esi),%esi
80108280:	89 c1                	mov    %eax,%ecx
80108282:	8b 55 10             	mov    0x10(%ebp),%edx
80108285:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80108288:	31 ff                	xor    %edi,%edi
8010828a:	e8 41 fb ff ff       	call   80107dd0 <deallocuvm.part.0>
8010828f:	eb 92                	jmp    80108223 <allocuvm+0xb3>
80108291:	eb 0d                	jmp    801082a0 <deallocuvm>
80108293:	90                   	nop
80108294:	90                   	nop
80108295:	90                   	nop
80108296:	90                   	nop
80108297:	90                   	nop
80108298:	90                   	nop
80108299:	90                   	nop
8010829a:	90                   	nop
8010829b:	90                   	nop
8010829c:	90                   	nop
8010829d:	90                   	nop
8010829e:	90                   	nop
8010829f:	90                   	nop

801082a0 <deallocuvm>:
{
801082a0:	55                   	push   %ebp
801082a1:	89 e5                	mov    %esp,%ebp
801082a3:	8b 55 0c             	mov    0xc(%ebp),%edx
801082a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801082a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801082ac:	39 d1                	cmp    %edx,%ecx
801082ae:	73 10                	jae    801082c0 <deallocuvm+0x20>
}
801082b0:	5d                   	pop    %ebp
801082b1:	e9 1a fb ff ff       	jmp    80107dd0 <deallocuvm.part.0>
801082b6:	8d 76 00             	lea    0x0(%esi),%esi
801082b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801082c0:	89 d0                	mov    %edx,%eax
801082c2:	5d                   	pop    %ebp
801082c3:	c3                   	ret    
801082c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801082ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801082d0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801082d0:	55                   	push   %ebp
801082d1:	89 e5                	mov    %esp,%ebp
801082d3:	57                   	push   %edi
801082d4:	56                   	push   %esi
801082d5:	53                   	push   %ebx
801082d6:	83 ec 0c             	sub    $0xc,%esp
801082d9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801082dc:	85 f6                	test   %esi,%esi
801082de:	74 59                	je     80108339 <freevm+0x69>
801082e0:	31 c9                	xor    %ecx,%ecx
801082e2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801082e7:	89 f0                	mov    %esi,%eax
801082e9:	e8 e2 fa ff ff       	call   80107dd0 <deallocuvm.part.0>
801082ee:	89 f3                	mov    %esi,%ebx
801082f0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801082f6:	eb 0f                	jmp    80108307 <freevm+0x37>
801082f8:	90                   	nop
801082f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108300:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108303:	39 fb                	cmp    %edi,%ebx
80108305:	74 23                	je     8010832a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80108307:	8b 03                	mov    (%ebx),%eax
80108309:	a8 01                	test   $0x1,%al
8010830b:	74 f3                	je     80108300 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010830d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108312:	83 ec 0c             	sub    $0xc,%esp
80108315:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108318:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010831d:	50                   	push   %eax
8010831e:	e8 8d a3 ff ff       	call   801026b0 <kfree>
80108323:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108326:	39 fb                	cmp    %edi,%ebx
80108328:	75 dd                	jne    80108307 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010832a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010832d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108330:	5b                   	pop    %ebx
80108331:	5e                   	pop    %esi
80108332:	5f                   	pop    %edi
80108333:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108334:	e9 77 a3 ff ff       	jmp    801026b0 <kfree>
    panic("freevm: no pgdir");
80108339:	83 ec 0c             	sub    $0xc,%esp
8010833c:	68 d5 91 10 80       	push   $0x801091d5
80108341:	e8 4a 80 ff ff       	call   80100390 <panic>
80108346:	8d 76 00             	lea    0x0(%esi),%esi
80108349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108350 <setupkvm>:
{
80108350:	55                   	push   %ebp
80108351:	89 e5                	mov    %esp,%ebp
80108353:	56                   	push   %esi
80108354:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108355:	e8 06 a5 ff ff       	call   80102860 <kalloc>
8010835a:	85 c0                	test   %eax,%eax
8010835c:	89 c6                	mov    %eax,%esi
8010835e:	74 42                	je     801083a2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80108360:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108363:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80108368:	68 00 10 00 00       	push   $0x1000
8010836d:	6a 00                	push   $0x0
8010836f:	50                   	push   %eax
80108370:	e8 fb d7 ff ff       	call   80105b70 <memset>
80108375:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108378:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010837b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010837e:	83 ec 08             	sub    $0x8,%esp
80108381:	8b 13                	mov    (%ebx),%edx
80108383:	ff 73 0c             	pushl  0xc(%ebx)
80108386:	50                   	push   %eax
80108387:	29 c1                	sub    %eax,%ecx
80108389:	89 f0                	mov    %esi,%eax
8010838b:	e8 b0 f9 ff ff       	call   80107d40 <mappages>
80108390:	83 c4 10             	add    $0x10,%esp
80108393:	85 c0                	test   %eax,%eax
80108395:	78 19                	js     801083b0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108397:	83 c3 10             	add    $0x10,%ebx
8010839a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
801083a0:	75 d6                	jne    80108378 <setupkvm+0x28>
}
801083a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801083a5:	89 f0                	mov    %esi,%eax
801083a7:	5b                   	pop    %ebx
801083a8:	5e                   	pop    %esi
801083a9:	5d                   	pop    %ebp
801083aa:	c3                   	ret    
801083ab:	90                   	nop
801083ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801083b0:	83 ec 0c             	sub    $0xc,%esp
801083b3:	56                   	push   %esi
      return 0;
801083b4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801083b6:	e8 15 ff ff ff       	call   801082d0 <freevm>
      return 0;
801083bb:	83 c4 10             	add    $0x10,%esp
}
801083be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801083c1:	89 f0                	mov    %esi,%eax
801083c3:	5b                   	pop    %ebx
801083c4:	5e                   	pop    %esi
801083c5:	5d                   	pop    %ebp
801083c6:	c3                   	ret    
801083c7:	89 f6                	mov    %esi,%esi
801083c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801083d0 <kvmalloc>:
{
801083d0:	55                   	push   %ebp
801083d1:	89 e5                	mov    %esp,%ebp
801083d3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801083d6:	e8 75 ff ff ff       	call   80108350 <setupkvm>
801083db:	a3 44 85 11 80       	mov    %eax,0x80118544
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801083e0:	05 00 00 00 80       	add    $0x80000000,%eax
801083e5:	0f 22 d8             	mov    %eax,%cr3
}
801083e8:	c9                   	leave  
801083e9:	c3                   	ret    
801083ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801083f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801083f0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801083f1:	31 c9                	xor    %ecx,%ecx
{
801083f3:	89 e5                	mov    %esp,%ebp
801083f5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801083f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801083fb:	8b 45 08             	mov    0x8(%ebp),%eax
801083fe:	e8 bd f8 ff ff       	call   80107cc0 <walkpgdir>
  if(pte == 0)
80108403:	85 c0                	test   %eax,%eax
80108405:	74 05                	je     8010840c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80108407:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010840a:	c9                   	leave  
8010840b:	c3                   	ret    
    panic("clearpteu");
8010840c:	83 ec 0c             	sub    $0xc,%esp
8010840f:	68 e6 91 10 80       	push   $0x801091e6
80108414:	e8 77 7f ff ff       	call   80100390 <panic>
80108419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108420 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108420:	55                   	push   %ebp
80108421:	89 e5                	mov    %esp,%ebp
80108423:	57                   	push   %edi
80108424:	56                   	push   %esi
80108425:	53                   	push   %ebx
80108426:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108429:	e8 22 ff ff ff       	call   80108350 <setupkvm>
8010842e:	85 c0                	test   %eax,%eax
80108430:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108433:	0f 84 9f 00 00 00    	je     801084d8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108439:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010843c:	85 c9                	test   %ecx,%ecx
8010843e:	0f 84 94 00 00 00    	je     801084d8 <copyuvm+0xb8>
80108444:	31 ff                	xor    %edi,%edi
80108446:	eb 4a                	jmp    80108492 <copyuvm+0x72>
80108448:	90                   	nop
80108449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108450:	83 ec 04             	sub    $0x4,%esp
80108453:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80108459:	68 00 10 00 00       	push   $0x1000
8010845e:	53                   	push   %ebx
8010845f:	50                   	push   %eax
80108460:	e8 bb d7 ff ff       	call   80105c20 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108465:	58                   	pop    %eax
80108466:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010846c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108471:	5a                   	pop    %edx
80108472:	ff 75 e4             	pushl  -0x1c(%ebp)
80108475:	50                   	push   %eax
80108476:	89 fa                	mov    %edi,%edx
80108478:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010847b:	e8 c0 f8 ff ff       	call   80107d40 <mappages>
80108480:	83 c4 10             	add    $0x10,%esp
80108483:	85 c0                	test   %eax,%eax
80108485:	78 61                	js     801084e8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80108487:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010848d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80108490:	76 46                	jbe    801084d8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108492:	8b 45 08             	mov    0x8(%ebp),%eax
80108495:	31 c9                	xor    %ecx,%ecx
80108497:	89 fa                	mov    %edi,%edx
80108499:	e8 22 f8 ff ff       	call   80107cc0 <walkpgdir>
8010849e:	85 c0                	test   %eax,%eax
801084a0:	74 61                	je     80108503 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801084a2:	8b 00                	mov    (%eax),%eax
801084a4:	a8 01                	test   $0x1,%al
801084a6:	74 4e                	je     801084f6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801084a8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801084aa:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801084af:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801084b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801084b8:	e8 a3 a3 ff ff       	call   80102860 <kalloc>
801084bd:	85 c0                	test   %eax,%eax
801084bf:	89 c6                	mov    %eax,%esi
801084c1:	75 8d                	jne    80108450 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801084c3:	83 ec 0c             	sub    $0xc,%esp
801084c6:	ff 75 e0             	pushl  -0x20(%ebp)
801084c9:	e8 02 fe ff ff       	call   801082d0 <freevm>
  return 0;
801084ce:	83 c4 10             	add    $0x10,%esp
801084d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801084d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801084db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084de:	5b                   	pop    %ebx
801084df:	5e                   	pop    %esi
801084e0:	5f                   	pop    %edi
801084e1:	5d                   	pop    %ebp
801084e2:	c3                   	ret    
801084e3:	90                   	nop
801084e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801084e8:	83 ec 0c             	sub    $0xc,%esp
801084eb:	56                   	push   %esi
801084ec:	e8 bf a1 ff ff       	call   801026b0 <kfree>
      goto bad;
801084f1:	83 c4 10             	add    $0x10,%esp
801084f4:	eb cd                	jmp    801084c3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801084f6:	83 ec 0c             	sub    $0xc,%esp
801084f9:	68 0a 92 10 80       	push   $0x8010920a
801084fe:	e8 8d 7e ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108503:	83 ec 0c             	sub    $0xc,%esp
80108506:	68 f0 91 10 80       	push   $0x801091f0
8010850b:	e8 80 7e ff ff       	call   80100390 <panic>

80108510 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108510:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108511:	31 c9                	xor    %ecx,%ecx
{
80108513:	89 e5                	mov    %esp,%ebp
80108515:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108518:	8b 55 0c             	mov    0xc(%ebp),%edx
8010851b:	8b 45 08             	mov    0x8(%ebp),%eax
8010851e:	e8 9d f7 ff ff       	call   80107cc0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108523:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108525:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108526:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108528:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010852d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108530:	05 00 00 00 80       	add    $0x80000000,%eax
80108535:	83 fa 05             	cmp    $0x5,%edx
80108538:	ba 00 00 00 00       	mov    $0x0,%edx
8010853d:	0f 45 c2             	cmovne %edx,%eax
}
80108540:	c3                   	ret    
80108541:	eb 0d                	jmp    80108550 <copyout>
80108543:	90                   	nop
80108544:	90                   	nop
80108545:	90                   	nop
80108546:	90                   	nop
80108547:	90                   	nop
80108548:	90                   	nop
80108549:	90                   	nop
8010854a:	90                   	nop
8010854b:	90                   	nop
8010854c:	90                   	nop
8010854d:	90                   	nop
8010854e:	90                   	nop
8010854f:	90                   	nop

80108550 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108550:	55                   	push   %ebp
80108551:	89 e5                	mov    %esp,%ebp
80108553:	57                   	push   %edi
80108554:	56                   	push   %esi
80108555:	53                   	push   %ebx
80108556:	83 ec 1c             	sub    $0x1c,%esp
80108559:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010855c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010855f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108562:	85 db                	test   %ebx,%ebx
80108564:	75 40                	jne    801085a6 <copyout+0x56>
80108566:	eb 70                	jmp    801085d8 <copyout+0x88>
80108568:	90                   	nop
80108569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108570:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108573:	89 f1                	mov    %esi,%ecx
80108575:	29 d1                	sub    %edx,%ecx
80108577:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010857d:	39 d9                	cmp    %ebx,%ecx
8010857f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108582:	29 f2                	sub    %esi,%edx
80108584:	83 ec 04             	sub    $0x4,%esp
80108587:	01 d0                	add    %edx,%eax
80108589:	51                   	push   %ecx
8010858a:	57                   	push   %edi
8010858b:	50                   	push   %eax
8010858c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010858f:	e8 8c d6 ff ff       	call   80105c20 <memmove>
    len -= n;
    buf += n;
80108594:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80108597:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010859a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801085a0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801085a2:	29 cb                	sub    %ecx,%ebx
801085a4:	74 32                	je     801085d8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801085a6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801085a8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801085ab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801085ae:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801085b4:	56                   	push   %esi
801085b5:	ff 75 08             	pushl  0x8(%ebp)
801085b8:	e8 53 ff ff ff       	call   80108510 <uva2ka>
    if(pa0 == 0)
801085bd:	83 c4 10             	add    $0x10,%esp
801085c0:	85 c0                	test   %eax,%eax
801085c2:	75 ac                	jne    80108570 <copyout+0x20>
  }
  return 0;
}
801085c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801085c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801085cc:	5b                   	pop    %ebx
801085cd:	5e                   	pop    %esi
801085ce:	5f                   	pop    %edi
801085cf:	5d                   	pop    %ebp
801085d0:	c3                   	ret    
801085d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801085d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801085db:	31 c0                	xor    %eax,%eax
}
801085dd:	5b                   	pop    %ebx
801085de:	5e                   	pop    %esi
801085df:	5f                   	pop    %edi
801085e0:	5d                   	pop    %ebp
801085e1:	c3                   	ret    
