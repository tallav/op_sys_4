#include "types.h"
#include "stat.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"

#define MAX_PROCESSES 64

//-------------------------HELPERS---------------------------------------
void itoa(char s[], int n)
 {
     int i=0, pm=n;
     int t, j;
     char c;
     
     if (pm < 0)  
         n = -n;          

     do 
     {       
         s[i++] = n % 10 + '0';   
     } while ((n /= 10) > 0);
     
     if (pm < 0)
         s[i++] = '-';
     
     s[i] = '\0';
     
     //reverse
     for (t = 0, j = strlen(s)-1; t<j; t++, j--) 
     {
         c = s[t];
         s[t] = s[j];
         s[j] = c;
     }
}

int atoi(char *buf) {
	int num = 0;

	while (*buf != '\0') {
		num = num * 10 + ((int)(*buf) - '0');
		buf++;
	}
	return num;
}

char*
strcpy(char *s, char *t)
{
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    ;
  return os;
}
//--------------------------------------------------------

struct process_entry {
	int pid;
	int used;
};

struct process_entry process_entries[MAX_PROCESSES];

struct dirent dir_entries[MAX_PROCESSES+2];

struct dirent subdir_entries[5];

struct dirent fd_dir_entries[NOFILE];


void update_dir_entries(int inum) {
	
	memset(dir_entries, sizeof(dir_entries), 0);

  memmove(&dir_entries[0].name, "proc", 5);
  memmove(&dir_entries[1].name, "pid", 4);
  memmove(&dir_entries[2].name, "ideinfo", 8);
  memmove(&dir_entries[3].name, "filestat", 9);
  memmove(&dir_entries[4].name, "inodeinfo", 10);

  subdir_entries[0].inum = inum;
  subdir_entries[1].inum = 601;
  subdir_entries[2].inum = 602;
  subdir_entries[3].inum = 603;
  subdir_entries[4].inum = 604;

	
  int i;
  int j = 5;
  int index = 605;
    for (i = 0; i < MAX_PROCESSES; i++) {
		if (process_entries[i].used) {
			itoa(dir_entries[j].name, process_entries[i].pid);
			dir_entries[j].inum = index;
      cprintf("dir_entries: inum =%d , name = %s , pid = %d \n", index, dir_entries[j].name, process_entries[i].pid);
			index++;
			j++;
		}
	}
}

int 
procfsisdir(struct inode *ip) {
  cprintf("in func procfsISDIR: ip->minor=%d ip->inum=%d\n", ip->minor, ip->inum);
  if (ip->minor == 0 || (ip->minor == 1 && (ip->inum == 603 || ip->inum == 601)))
		return 1;
	else 
    return 0;
}

void 
procfsiread(struct inode* dp, struct inode *ip) {
  cprintf("in func PROCFSIREAD, ip->inum= %d, dp->inum = %d \n",ip->inum,dp->inum);
  if (ip->inum < 600) 
		return;

	ip->major = PROCFS;
	ip->size = 0;
	ip->nlink = 1;
	ip->type = T_DEV;
	ip->valid = 1;
	ip->minor = dp->minor + 1;

	//if (dp->inum < ip->inum)
  //  ip->minor = dp->minor + 1;
}

int read_file_filestat(struct inode *ip, char *dst, int off, int n){
  cprintf("read_file_filestat, ip->inum = %d\n", ip->inum);

  if (n == sizeof(struct dirent))
		return 0;
	

	char data[256] = {0};

	strcpy(data, "just for testing: ");
	itoa(data + strlen(data), 10);
	

	if (off + n > strlen(data))
		n = strlen(data) - off;
	memmove(dst, (char*)(&data) + off, n);
return n;
}

int read_path_level_0(struct inode *ip, char *dst, int off, int n){

  cprintf("in func read_path_level_0, ip->inum=%d\n",ip->inum);
  update_dir_entries(ip->inum);

  if (off + n > sizeof(dir_entries))
      n = sizeof(dir_entries) - off;
  memmove(dst, (char*)(&dir_entries) + off, n);

  return n;
}

int read_path_level_1(struct inode *ip, char *dst, int off, int n){
  cprintf("in func read_path_level_1, ip->inum=%d \n",ip->inum);
  switch (ip->inum) {
      case 602:
        return 0;//return read_file_ideinfo(ip, dst, off, n);
      case 603:
        return read_file_filestat(ip, dst, off, n);
      case 604:
        return 0; //return read_file_inodeinfo(ip, dst, off, n); //should be a directory
      default:
        return 0;//return read_procfs_pid_dir(ip, dst, off, n);
  }
}

int read_path_level_2(struct inode *ip, char *dst, int off, int n){
    return 0; // todo
}

int read_path_level_3(struct inode *ip, char *dst, int off, int n){
    return 0; // todo
}



int
procfsread(struct inode *ip, char *dst, int off, int n) {
  cprintf("In func PROCFSREAD , minor= %d \n",ip->minor);
  switch (ip->minor){
    case 0:
      return read_path_level_0(ip,dst,off,n);
    case 1:
      return read_path_level_1(ip,dst,off,n);
    case 2:
      return read_path_level_2(ip,dst,off,n);
    case 3:
      return read_path_level_3(ip,dst,off,n);
    default:
      return -1;
  }
}

int
procfswrite(struct inode *ip, char *buf, int n)
{
  return 0;
}

void
procfsinit(void)
{
  cprintf("in func procsfinit\n");

  devsw[PROCFS].isdir = procfsisdir;
  devsw[PROCFS].iread = procfsiread;
  devsw[PROCFS].write = procfswrite;
  devsw[PROCFS].read = procfsread;

  memset(&process_entries, sizeof(process_entries), 0);

  memmove(&subdir_entries[0].name, "name", 5);
  memmove(&subdir_entries[1].name, "status", 7);


  subdir_entries[0].inum = 800;
  subdir_entries[1].inum = 801;
 
}
void procfs_add_proc(int pid, char* cwd) {
	int i;
	//cprintf("procfs_add_proc: %d\n", pid);
	for (i = 0; i < MAX_PROCESSES; i++) {
		if (!process_entries[i].used) {
			process_entries[i].used = 1;
			process_entries[i].pid = pid;
			return;
		}
	}
	panic("Too many processes in procfs!");
}

void procfs_remove_proc(int pid) {
	//cprintf("procfs_remove_proc: %d\n", pid);
	int i;
	for (i = 0; i < MAX_PROCESSES; i++) {
		if (process_entries[i].used && process_entries[i].pid == pid) {
			process_entries[i].used = process_entries[i].pid = 0;
			return;
		}
	}
	panic("Failed to find process in procfs_remove_proc!");
}