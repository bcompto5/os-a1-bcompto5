#include "kernel/types.h"
#include "kernel/uproc.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  struct uproc p[64];
  int n, i;
  char *state;

  n = getprocs(p, 64);
  if(n < 0){
    fprintf(2, "ps: getprocs failed\n");
    exit(1);
  }

  printf("PID\tPPID\tSTATE\tSIZE\tNAME\n");

  for(i = 0; i < n; i++){
    state = "???";

    // Values follow enum procstate in kernel/proc.h.
    if(p[i].state == 1)
      state = "used";
    else if(p[i].state == 2)
      state = "sleeping";
    else if(p[i].state == 3)
      state = "runnable";
    else if(p[i].state == 4)
      state = "running";
    else if(p[i].state == 5)
      state = "zombie";

    printf("%d\t%d\t%s\t%lu\t%s\n",
           p[i].pid, p[i].ppid, state, p[i].sz, p[i].name);
  }

  exit(0);
}
