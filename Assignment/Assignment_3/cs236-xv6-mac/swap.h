#ifndef _SWAP_H_
#define _SWAP_H_

#include "param.h"    // for SWAP_SLOTS

// Forward-declare the kernel’s spinlock type
struct spinlock;

// One swap‐slot per 4 KiB page (8 × 512 B blocks)
struct swap_slot {
  int page_perm;   // saved PTE flags (W/U/etc)
  int is_free;     // 1 => free, 0 => in use
};

// The single global table and its lock:
extern struct swap_slot swap_slots[SWAP_SLOTS];
extern struct spinlock  slock;

// Initialize swap_slots[] at boot
void init_swap(void);

#endif  // _SWAP_H_
