#include "types.h"
#include "user.h"
#include "fcntl.h"
// You can write a small user program that allocates memory to see if the page count changes.
int
main(int argc, char *argv[])
{
  // Allocate an array of 4096 * 10 bytes (i.e. 10 pages)
  char *mem = malloc(4096 * 10);
  if(mem == 0){
    printf(2, "Memory allocation failed\n");
    exit();
  }
  sleep(1000);
  // Touch each page to ensure it is allocated.
  for (int i = 0; i < 10; i++) {
    mem[i * 4096] = i;
  }
  
  printf(1, "Allocated 10 pages of memory\n");

  // Wait for user input so you can test memory printer:
  printf(1, "Press Ctrl+I in another terminal window, then hit Enter here to exit.\n");
  char buf[10];
  gets(buf, sizeof(buf));
  char *mem1 = malloc(4096 * 10000);
  if(mem1 == 0){
    printf(2, "Memory allocation failed\n");
    exit();
  }

  for (int i = 0; i < 10000; i++) {
    mem1[i * 4096] = i;
  }
  free(mem);
  free(mem1);
  printf(1, "Press Ctrl+I in another terminal window, then hit Enter here to exit.\n");
  gets(buf, sizeof(buf));
  exit();
}


