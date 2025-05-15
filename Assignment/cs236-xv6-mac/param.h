#define NPROC        64  // maximum number of processes
#define KSTACKSIZE 4096  // size of per-process kernel stack
#define NCPU          8  // maximum number of CPUs
#define NOFILE       16  // open files per process
#define NFILE       100  // open files per system
#define NINODE       50  // maximum number of active i-nodes
#define NDEV         10  // maximum major device number
#define ROOTDEV       1  // device number of file system root disk
#define MAXARG       32  // max exec arguments
#define MAXOPBLOCKS  10  // max # of blocks any FS op writes
#define LOGSIZE      (MAXOPBLOCKS*3)  // max data blocks in on-disk log
#define NBUF         (MAXOPBLOCKS*3)  // size of disk block cache
// #define FSSIZE       1000  // size of file system in blocks


//.................
// #define FSSIZE         10000                           // size of file system in blocks
#define NSPAGESLOTS    800                             // how many pages we can swap
#define SWAP_SLOTS     800                             // number of swap slots reserved for paging
#define SWAPSTART      2                               // first block of swap area (after superblock)&#8203;:contentReference[oaicite:2]{index=2}
#define PAGES_PER_SLOT 8                               // 4096B page / 512B block or in one slot total 8 disk block 
#define SWAP_BLOCKS    (NSPAGESLOTS * PAGES_PER_SLOT)  //no. of disk block(6400 disk block) in swap area

#define FSSIZE    (10000 + SWAP_BLOCKS)                // now the no. of disk block is 10000 + 6400

//.................

