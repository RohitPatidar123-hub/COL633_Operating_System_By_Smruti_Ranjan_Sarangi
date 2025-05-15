#ifndef BUF_H
#define BUF_H
#include "param.h"       // for BSIZE
#include "sleeplock.h"   // for struct sleeplock
#define BSIZE 512 
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

#endif  // BUF_H

