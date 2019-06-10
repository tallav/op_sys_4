struct buf {
  int flags;
  uint dev;
  uint blockno;
  struct sleeplock lock;
  uint refcnt;
  struct buf *prev; // LRU cache list
  struct buf *next;
  struct buf *qnext; // disk queue
  uchar data[BSIZE];
};
#define B_VALID 0x2  // buffer has been read from disk
#define B_DIRTY 0x4  // buffer needs to be written to disk

struct tempbuf {
  uint device_num;
  uint block_num;
  struct tempbuf *next;
};

int get_waiting_ops(void);
int get_read_wait_ops(void);
int get_write_wait_ops(void);
struct tempbuf* get_working_blocks(void);
