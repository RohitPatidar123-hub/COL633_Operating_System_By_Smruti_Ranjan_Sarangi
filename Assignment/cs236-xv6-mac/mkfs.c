#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <assert.h>

#define stat xv6_stat  // avoid clash with host struct stat
#include "types.h"
#include "fs.h"
#include "stat.h"
#include "param.h"
#define min(a,b) ((a) < (b) ? (a) : (b))
#ifndef static_assert
#define static_assert(a, b) do { switch (0) case 0: case (a): ; } while (0)
#endif

#define NINODES 200


//...............................

// ——— swap area definitions ———
// #define NSPAGESLOTS   800
// #define PAGES_PER_SLOT 8
// #define SWAP_BLOCKS   (NSPAGESLOTS * PAGES_PER_SLOT)
// #define FSSIZE       (1000 + SWAP_BLOCKS) // total size of the file system
// struct swap_slot {
//     int perm;    // permissions of the swapped page
//     int is_free; // availability (1 if free, 0 if occupied)
// } swap_slots[800];

// #define SWAPSIZE (800 * 8) // 800 pages * 8 blocks per page
// // mkfs.c modification (simplified example)
// uint nswap = SWAPSIZE;
// uint swapstart = 2; // After sb block (block 1), swap starts at block 2
// uint logstart = swapstart + nswap; // log starts immediately after swap blocks





//...............................
// Disk layout:
// [ boot block | sb block | log | inode blocks | free bit map | data blocks ]

int nbitmap = FSSIZE/(BSIZE*8) + 1; //no of bit map block needed to track  all FSSIZE blocks
int ninodeblocks = NINODES / IPB + 1; // no of inode block per block.  Each block (BSIZE bytes) holds IPB = BSIZE/sizeof(struct dinode) inodes. Divide the total inodes by that, round up. That many blocks are reserved to store all the dinode structs.
int nlog = LOGSIZE; // Number of blocks reserved for the file‐system write‐ahead log. no of log blocks.  The log is a circular buffer of size LOGSIZE blocks.  It is used to store the most recent transactions (writes) to the file system.  The log is used to recover the file system in case of a crash or power failure.  The log is written to disk in a circular fashion, so that when it reaches the end, it wraps around to the beginning.
int nmeta;    // Number of meta blocks (boot, sb, nlog, inode, bitmap)
int nblocks;  // Number of data blocks

int fsfd;
struct superblock sb;
char zeroes[BSIZE];
uint freeinode = 1;
uint freeblock;


void balloc(int);
void wsect(uint, void*);
void winode(uint, struct dinode*);
void rinode(uint inum, struct dinode *ip);
void rsect(uint sec, void *buf);
uint ialloc(ushort type);
void iappend(uint inum, void *p, int n);

// convert to intel byte order
ushort
xshort(ushort x)
{
  ushort y;
  uchar *a = (uchar*)&y;
  a[0] = x;
  a[1] = x >> 8;
  return y;
}

uint
xint(uint x)
{
  uint y;
  uchar *a = (uchar*)&y;
  a[0] = x;
  a[1] = x >> 8;
  a[2] = x >> 16;
  a[3] = x >> 24;
  return y;
}

int
main(int argc, char *argv[])
{
  int i, cc, fd;
  uint rootino, inum, off;
  struct dirent de;
  char buf[BSIZE];
  struct dinode din;


  static_assert(sizeof(int) == 4, "Integers must be 4 bytes!");

  if(argc < 2){
    fprintf(stderr, "Usage: mkfs fs.img files...\n");
    exit(1);
  }

  assert((BSIZE % sizeof(struct dinode)) == 0);
  assert((BSIZE % sizeof(struct dirent)) == 0);

  fsfd = open(argv[1], O_RDWR|O_CREAT|O_TRUNC, 0666);
  if(fsfd < 0){
    perror(argv[1]);
    exit(1);
  }

  // 1 fs block = 1 disk sector
  // nmeta = 2 + nlog + ninodeblocks + nbitmap;
  nmeta = 2 +  SWAP_BLOCKS  /* our swap area */ + nlog + ninodeblocks + nbitmap;

  nblocks = FSSIZE - nmeta;

  sb.size = xint(FSSIZE);// this xint convert to little endian
  sb.nblocks = xint(nblocks);
  sb.ninodes = xint(NINODES);
  sb.nlog = xint(nlog);
  // sb.logstart = xint(2);
  // sb.inodestart = xint(2+nlog);
  // sb.bmapstart = xint(2+nlog+ninodeblocks);

   // shift all starts down by SWAP_BLOCKS
  sb.logstart    = xint(2 + SWAP_BLOCKS);
  sb.inodestart  = xint(2 + SWAP_BLOCKS + nlog);
  sb.bmapstart   = xint(2 + SWAP_BLOCKS + nlog + ninodeblocks);


  printf("nmeta %d (boot, super, log blocks %u inode blocks %u, bitmap blocks %u) blocks %d total %d\n",
         nmeta, nlog, ninodeblocks, nbitmap, nblocks, FSSIZE);

  freeblock = nmeta;     // the first free block that we can allocate

  for(i = 0; i < FSSIZE; i++) // This loop “formats” the disk by zeroing every block
    wsect(i, zeroes);

  memset(buf, 0, sizeof(buf)); // after this call, every byte in buf is set to 0x00
  memmove(buf, &sb, sizeof(sb)); // writes your superblock struct into the beginning of that cleared block.
  wsect(1, buf);   // writes the result to disk, giving xv6 a valid superblock on which to mount the file system.

  rootino = ialloc(T_DIR); // Allocate an inode for the root directory.  The root directory is a special directory that contains all other files and directories in the file system.  It is always assigned inode number 1.
  assert(rootino == ROOTINO); // The root inode number is always 1.  This is a special case in the file system.

  bzero(&de, sizeof(de));       // 	Zero out the dirent for clean initialization
  de.inum = xshort(rootino);    // 	Point this entry to the root inode (with correct endian format)
  strcpy(de.name, ".");         // 	Fill in the name of the entry with a dot (.) to indicate the current directory
  iappend(rootino, &de, sizeof(de));

  bzero(&de, sizeof(de));
  de.inum = xshort(rootino);
  strcpy(de.name, "..");
  iappend(rootino, &de, sizeof(de));

  for(i = 2; i < argc; i++){
    assert(index(argv[i], '/') == 0);

    if((fd = open(argv[i], 0)) < 0){
      perror(argv[i]);
      exit(1);
    }

    // Skip leading _ in name when writing to file system.
    // The binaries are named _rm, _cat, etc. to keep the
    // build operating system from trying to execute them
    // in place of system binaries like rm and cat.
    if(argv[i][0] == '_')
      ++argv[i];

    inum = ialloc(T_FILE);

    bzero(&de, sizeof(de));
    de.inum = xshort(inum);
    strncpy(de.name, argv[i], DIRSIZ);
    iappend(rootino, &de, sizeof(de));

    while((cc = read(fd, buf, sizeof(buf))) > 0)
      iappend(inum, buf, cc);

    close(fd);
  }

  // fix size of root inode dir
  rinode(rootino, &din);
  off = xint(din.size);
  off = ((off/BSIZE) + 1) * BSIZE;
  din.size = xint(off);
  winode(rootino, &din);

  balloc(freeblock);

  exit(0);
}

void
wsect(uint sec, void *buf)
{
  if(lseek(fsfd, sec * BSIZE, 0) != sec * BSIZE){
    perror("lseek");
    exit(1);
  }
  if(write(fsfd, buf, BSIZE) != BSIZE){
    perror("write");
    exit(1);
  }
}

void
winode(uint inum, struct dinode *ip)
{
  char buf[BSIZE];
  uint bn;
  struct dinode *dip;

  bn = IBLOCK(inum, sb);
  rsect(bn, buf);
  dip = ((struct dinode*)buf) + (inum % IPB);
  *dip = *ip;
  wsect(bn, buf);
}

void
rinode(uint inum, struct dinode *ip)
{
  char buf[BSIZE];
  uint bn;
  struct dinode *dip;

  bn = IBLOCK(inum, sb);
  rsect(bn, buf);
  dip = ((struct dinode*)buf) + (inum % IPB);
  *ip = *dip;
}

void
rsect(uint sec, void *buf)
{
  if(lseek(fsfd, sec * BSIZE, 0) != sec * BSIZE){
    perror("lseek");
    exit(1);
  }
  if(read(fsfd, buf, BSIZE) != BSIZE){
    perror("read");
    exit(1);
  }
}

uint
ialloc(ushort type)
{
  uint inum = freeinode++;
  struct dinode din;

  bzero(&din, sizeof(din));  // Zero out the in-memory inode structure ..Clears all fields (type, device numbers, link count, size, block pointers).
  din.type = xshort(type); // Initialize key fields..... Set the type of the inode (T_DIR or T_FILE).
  din.nlink = xshort(1);  // Set the link count to 1 (indicating one reference to this inode).
  din.size = xint(0);     // Set the size of the file to 0.
  winode(inum, &din);     // Write the inode to the disk.
  return inum;       
}

// void
// balloc(int used)
// {
//   uchar buf[BSIZE];
//   int i;

//   printf("balloc: first %d blocks have been allocated\n", used);
//   assert(used < BSIZE*8);
//   bzero(buf, BSIZE);
//   for(i = 0; i < used; i++){
//     buf[i/8] = buf[i/8] | (0x1 << (i%8));
//   }
//   printf("balloc: write bitmap block at sector %d\n", sb.bmapstart);
//   wsect(sb.bmapstart, buf);
// }

//..........................................................................................................

void
balloc(int used)
 {
   uchar buf[BSIZE];
   int i;
   int bidx, start, end;
 
// -  printf("balloc: first %d blocks have been allocated\n", used);
// -  assert(used < BSIZE*8);
// -  bzero(buf, BSIZE);
// -  for(i = 0; i < used; i++){
// -    buf[i/8] = buf[i/8] | (0x1 << (i%8));
// -  }
// -  printf("balloc: write bitmap block at sector %d\n", sb.bmapstart);
// -  wsect(sb.bmapstart, buf);
  printf("balloc: first %d blocks have been allocated\n", used);

  // loop over each bitmap block
  for(bidx = 0; bidx < nbitmap; bidx++){
    bzero(buf, BSIZE);
    // compute the block‐range this bitmap covers
    start = bidx * BSIZE * 8;
    end   = min(used, (bidx+1) * BSIZE * 8);
    // set bits for [start..end)
    for(i = start; i < end; i++){
      int off = i - start;
      buf[off/8] |= 1 << (off%8);
    }
    printf("balloc: write bitmap block at sector %d\n", sb.bmapstart + bidx);
    wsect(sb.bmapstart + bidx, buf);
  }
 }








//..........................................................................................................

#define min(a, b) ((a) < (b) ? (a) : (b))

void
iappend(uint inum, void *xp, int n)
{
  char *p = (char*)xp;
  uint fbn, off, n1;
  struct dinode din;
  char buf[BSIZE];
  uint indirect[NINDIRECT];
  uint x;

  rinode(inum, &din);
  off = xint(din.size);
  // printf("append inum %d at off %d sz %d\n", inum, off, n);
  while(n > 0){
    fbn = off / BSIZE;
    assert(fbn < MAXFILE);
    if(fbn < NDIRECT){
      if(xint(din.addrs[fbn]) == 0){
        din.addrs[fbn] = xint(freeblock++);
      }
      x = xint(din.addrs[fbn]);
    } else {
      if(xint(din.addrs[NDIRECT]) == 0){
        din.addrs[NDIRECT] = xint(freeblock++);
      }
      rsect(xint(din.addrs[NDIRECT]), (char*)indirect);
      if(indirect[fbn - NDIRECT] == 0){
        indirect[fbn - NDIRECT] = xint(freeblock++);
        wsect(xint(din.addrs[NDIRECT]), (char*)indirect);
      }
      x = xint(indirect[fbn-NDIRECT]);
    }
    n1 = min(n, (fbn + 1) * BSIZE - off);
    rsect(x, buf);
    bcopy(p, buf + off - (fbn * BSIZE), n1);
    wsect(x, buf);
    n -= n1;
    off += n1;
    p += n1;
  }
  din.size = xint(off);
  winode(inum, &din);
}
