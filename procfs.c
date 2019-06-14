#include "types.h"
#include "stat.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "buf.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"

// helpers
char* strcpy(char *s, const char *t);
int atoi(const char *s);
void itoa(char s[], int n);

struct process_entry {
	int pid;
	int used;
};

struct inode_entry {
	struct inode *inode;
	int used;
};

#define ROOT_INUM 1;

struct process_entry process_entries[NPROC];

struct dirent dir_entries[NPROC+2]; // +2 for curr and parent directory

struct dirent subdir_entries[4];

struct inode_entry inode_entries[NINODE];

struct dirent inodeinfo_dir_entries[NINODE+2];

int 
procfsisdir(struct inode *ip) 
{
  //cprintf("in func procfsisdir: ip->minor=%d ip->inum=%d\n", ip->minor, ip->inum);
  if (ip->minor == 0 || (ip->minor == 1 && (ip->inum != 500 || ip->inum != 501)))
		return 1;
	else 
    return 0;
}

void 
procfsiread(struct inode* dp, struct inode *ip) 
{
  //cprintf("in func PROCFSIREAD, ip->inum= %d, dp->inum = %d \n",ip->inum,dp->inum);
  if (ip->inum < 500) 
		return;

	ip->major = PROCFS;
	ip->size = 0;
	ip->nlink = 1;
	ip->type = T_DEV;
	ip->valid = 1;
	ip->minor = dp->minor + 1;

	if (dp->inum < ip->inum)
		ip->minor = dp->minor + 1;
	else if (dp->inum < ip->inum)
		ip->minor = dp->minor - 1;
}

int
procfsread(struct inode *ip, char *dst, int off, int n) 
{
  //cprintf("in func procfsread , minor=%d\n",ip->minor);
  switch (ip->minor){
    case 0:
      //cprintf("case 0\n");
      return read_path_level_0(ip,dst,off,n);
    case 1:
      //cprintf("case 1\n");
      return read_path_level_1(ip,dst,off,n);
    case 2:
      //cprintf("case 2\n");
      return read_path_level_2(ip,dst,off,n);
    case 3:
      cprintf("case 3\n");
      return read_path_level_3(ip,dst,off,n);
    default:
      cprintf("procfsread minor: %d", ip->minor);
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
  devsw[PROCFS].isdir = procfsisdir;
  devsw[PROCFS].iread = procfsiread;
  devsw[PROCFS].write = procfswrite;
  devsw[PROCFS].read = procfsread;

  memset(&process_entries, sizeof(process_entries), 0);
  memmove(subdir_entries[0].name, ".", 2);
  memmove(subdir_entries[1].name, "..", 3);
  memmove(subdir_entries[2].name, "name", 5);
  memmove(subdir_entries[3].name, "status", 7);
  subdir_entries[0].inum = 2;
  subdir_entries[1].inum = 1;
  subdir_entries[2].inum = 0; // temporary init- 
  subdir_entries[3].inum = 0; // will be initialized in read_procfs_pid_dir
}

void 
update_dir_entries(int inum) 
{
  //cprintf("in func update_dir_entries, inum=%d\n",inum);
	memset(dir_entries, sizeof(dir_entries), 0);

  memmove(&dir_entries[0].name, ".", 2);
  memmove(&dir_entries[1].name, "..", 3);
  memmove(&dir_entries[2].name, "ideinfo", 8);
  memmove(&dir_entries[3].name, "filestat", 9);
  memmove(&dir_entries[4].name, "inodeinfo", 10);

  dir_entries[0].inum = inum;
  dir_entries[1].inum = ROOT_INUM;
  dir_entries[2].inum = 500;
  dir_entries[3].inum = 501;
  dir_entries[4].inum = 502;

  int j = 5;
  for (int i = 0; i < NPROC; i++) {
		if (process_entries[i].used) {
			itoa(dir_entries[j].name, process_entries[i].pid);
			dir_entries[j].inum = 600 + process_entries[i].pid;
			j++;
		}
	}
}

void 
update_inode_entries(int inum) 
{
  //cprintf("in func update_inode_entries, inum=%d\n",inum);
	memset(inodeinfo_dir_entries, sizeof(inodeinfo_dir_entries), 0);

  memmove(&inodeinfo_dir_entries[0].name, ".", 2);
  memmove(&inodeinfo_dir_entries[1].name, "..", 3);
  
  inodeinfo_dir_entries[0].inum = inum;
  inodeinfo_dir_entries[1].inum = ROOT_INUM;

  int j = 2;
  for (int i = 0; i < NINODE; i++) {
    if (inode_entries[i].used) {
      int index = get_inode_index(inode_entries[i].inode->inum);
      if(index >= 0){ // if index==-1 it is not found in the open inode table (ichache)
        itoa(inodeinfo_dir_entries[j].name, index);
        inodeinfo_dir_entries[j].inum = 900 + index;
      }
      j++;
    }
  }
}

int 
read_path_level_0(struct inode *ip, char *dst, int off, int n)
{
  //cprintf("in func read_path_level_0, ip->inum=%d\n",ip->inum);
  update_dir_entries(ip->inum);
  if (off + n > sizeof(dir_entries))
      n = sizeof(dir_entries) - off;
  memmove(dst, (char*)(&dir_entries) + off, n);
  return n;
}

char currQueueData[256] = {0};

char*
get_string_working_blocks(uint *q)
{
  strcpy(currQueueData, "Working blocks: ");

  for(int i=0; i < 256; i = i+2){
    if(q[i] != 0){
      strcpy(currQueueData + strlen(currQueueData), "(");
      itoa(currQueueData + strlen(currQueueData), q[i]);
      strcpy(currQueueData + strlen(currQueueData), ",");
      itoa(currQueueData + strlen(currQueueData), q[i+1]);
      strcpy(currQueueData + strlen(currQueueData), ");");
    }
  }

  return currQueueData;
}

// functions implementation in ide.c
int 
read_file_ideinfo(struct inode* ip, char *dst, int off, int n) 
{
  //cprintf("in func read_file_ideinfo\n");
  if (n == sizeof(struct dirent))
		return 0;

	char data[256] = {0};

	strcpy(data, "Waiting operations: ");
	itoa(data + strlen(data), get_waiting_ops());
	strcpy(data + strlen(data), "\nRead waiting operations: ");
	itoa(data + strlen(data), get_read_wait_ops());
	strcpy(data + strlen(data), "\nWrite waiting operations: ");
	itoa(data + strlen(data), get_write_wait_ops());
  strcpy(data + strlen(data), "\n");
  char* workBlocks = get_string_working_blocks(get_working_blocks());
  strcpy(data + strlen(data), workBlocks);
	strcpy(data + strlen(data), "\n");

	if (off + n > strlen(data))
		n = strlen(data) - off;
	memmove(dst, (char*)(&data) + off, n);
	return n;
}

// functions implementation in file.c
int 
read_file_filestat(struct inode* ip, char *dst, int off, int n) 
{
  if (n == sizeof(struct dirent))
		return 0;

	char data[256] = {0};

	strcpy(data, "Free fds: ");
	itoa(data + strlen(data), get_free_fds());
	strcpy(data + strlen(data), "\nUnique inode fds: ");
	itoa(data + strlen(data), get_unique_inode_fds()); // TODO
	strcpy(data + strlen(data), "\nWriteable fds: ");
	itoa(data + strlen(data), get_writeable_fds());
  strcpy(data + strlen(data), "\nReadable fds: ");
	itoa(data + strlen(data), get_readable_fds());
  strcpy(data + strlen(data), "\nRefs per fds: ");
	itoa(data + strlen(data), get_total_refs());
	strcpy(data + strlen(data), " / ");
	itoa(data + strlen(data), get_used_fds());
	strcpy(data + strlen(data), "\n");

	if (off + n > strlen(data))
		n = strlen(data) - off;
	memmove(dst, (char*)(&data) + off, n);
	return n;
}

// like level 0
int 
read_file_inodeinfo(struct inode* ip, char *dst, int off, int n) 
{
  //cprintf("in func read_path_level_0, ip->inum=%d\n",ip->inum);
  update_inode_entries(ip->inum);
  if (off + n > sizeof(inodeinfo_dir_entries))
      n = sizeof(inodeinfo_dir_entries) - off;
  memmove(dst, (char*)(&inodeinfo_dir_entries) + off, n);
  return n;
}

int 
read_procfs_pid_dir(struct inode* ip, char *dst, int off, int n) 
{
  //cprintf("in func read_procfs_pid_dir, ip->inum=%d \n",ip->inum);
  struct dirent temp_entries[4];
	memmove(&temp_entries, &subdir_entries, sizeof(subdir_entries));

	temp_entries[2].inum = ip->inum + 100;
	temp_entries[3].inum = ip->inum + 200;

	if (off + n > sizeof(temp_entries))
		n = sizeof(temp_entries) - off;
	memmove(dst, (char*)(&temp_entries) + off, n);
	return n;
}

int 
read_path_level_1(struct inode *ip, char *dst, int off, int n)
{
  //cprintf("in func read_path_level_1, ip->inum=%d \n",ip->inum);
  if(ip->inum > 900){

  }
  switch (ip->inum) {
    case 500:
      return read_file_ideinfo(ip, dst, off, n);
    case 501:
      return read_file_filestat(ip, dst, off, n);
    case 502:
      return read_file_inodeinfo(ip, dst, off, n); //should be a directory
    default:
      return read_procfs_pid_dir(ip, dst, off, n);
  }
}

int 
read_procfs_status(struct inode* ip, char *dst, int off, int n) 
{
  //cprintf("in func read_procfs_status, ip->inum=%d \n",ip->inum);
	char status[250] = {0};
	//char szBuf[100] = {0};
	char* procstate[6] = { "UNUSED", "EMBRYO", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE" };

	int pid = ip->inum - 800;
  struct proc *p = find_proc_by_pid(pid);

  int size = strlen(procstate[p->state]);
  strcpy(status, procstate[p->state]);
  status[size] = ' ';
  //itoa(szBuf, p->sz);
  //strcpy(status + size + 1, szBuf);

  status[strlen(status)] = '\n';

  int status_size = strlen(status);

  if (off + n > status_size)
    n = status_size - off;
  memmove(dst, (char*)(&status) + off, n);
  return n;
}

int 
read_procfs_name(struct inode* ip, char *dst, int off, int n) 
{
  //cprintf("in func read_procfs_name, ip->inum=%d \n",ip->inum);
	char name[250] = {0};
	//char szBuf[100] = {0};

	int pid = ip->inum - 700;
  struct proc *p = find_proc_by_pid(pid);

  int size = strlen(p->name);
  strcpy(name, p->name);
  name[size] = ' ';
  //itoa(szBuf, p->sz);
  //strcpy(name + size + 1, szBuf);

  name[strlen(name)] = '\n';

  int name_size = strlen(name);

  if (off + n > name_size)
    n = name_size - off;
  memmove(dst, (char*)(&name) + off, n);
  return n;
}

// TODO:
int 
read_inodeinfo_file(struct inode* ip, char *dst, int off, int n) 
{
  if (n == sizeof(struct dirent))
		return 0;

	char data[256] = {0};

	strcpy(data, "Device: ");
	itoa(data + strlen(data), ip->dev);
	strcpy(data + strlen(data), "\nInode number: ");
	itoa(data + strlen(data), ip->inum); 
	strcpy(data + strlen(data), "\nis valid: ");
	itoa(data + strlen(data), ip->valid);
  strcpy(data + strlen(data), "\ntype: ");
  if(ip->type == T_DIR)
    strcpy(data + strlen(data), "DIR");
  if(ip->type == T_FILE)
    strcpy(data + strlen(data), "FILE");
  if(ip->type == T_DEV)
    strcpy(data + strlen(data), "DEV");
  strcpy(data + strlen(data), "\nmajor minor: (");
	itoa(data + strlen(data), ip->major);
  strcpy(data + strlen(data), ", ");
	itoa(data + strlen(data), ip->minor);
  strcpy(data + strlen(data), ")");
	strcpy(data + strlen(data), "\nhard links: ");
	itoa(data + strlen(data), ip->ref);
  strcpy(data + strlen(data), "\nblocks used: ");
	// TODO: 
  if(ip->type == T_DEV)
    itoa(data + strlen(data), 0);
	strcpy(data + strlen(data), "\n");

	if (off + n > strlen(data))
		n = strlen(data) - off;
	memmove(dst, (char*)(&data) + off, n);
	return n;
}

int 
read_path_level_2(struct inode *ip, char *dst, int off, int n)
{
  //cprintf("in func read_path_level_2, ip->inum=%d \n",ip->inum);
  switch (ip->inum/100) {
    case 7:
      return read_procfs_name(ip, dst, off, n);
    case 8:
      return read_procfs_status(ip, dst, off, n);
    case 9:
      return read_inodeinfo_file(ip, dst, off, n);
    default:
      cprintf("level 2 no case for inum=%d\n", ip->inum);
	}
  
	return 0;
}

int 
read_path_level_3(struct inode *ip, char *dst, int off, int n)
{
  return 0; 
}

void 
procfs_add_proc(int pid) 
{
  //cprintf("procfs_add_proc: %d\n", pid);
	for (int i = 0; i < NPROC; i++) {
		if (!process_entries[i].used) {
			process_entries[i].used = 1;
			process_entries[i].pid = pid;
			return;
		}
	}
	panic("Too many processes in procfs!");
}

void
procfs_remove_proc(int pid) 
{
	//cprintf("procfs_remove_proc: %d\n", pid);
	int i;
	for (i = 0; i < NPROC; i++) {
		if (process_entries[i].used && process_entries[i].pid == pid) {
			process_entries[i].used = process_entries[i].pid = 0;
			return;
		}
	}
	panic("Failed to find process in procfs_remove_proc!");
}

// TODO: check if this array can have duplicates
// ls error printed sometimes
void 
procfs_add_inode(struct inode *inode) 
{
  //cprintf("procfs_add_inode: %d\n", inode->inum);
  int inodeExist = 0;
  for (int i = 0; i < NINODE; i++) {
		if (inode_entries[i].inode == inode) {
      inodeExist = 1;
			break;
		}
	}
  if(inodeExist){
    //cprintf("inode exist\n");
    return;
  }
	for (int i = 0; i < NINODE; i++) {
		if (!inode_entries[i].used) {
      inode_entries[i].used = 1;
			inode_entries[i].inode = inode;
			return;
		}
	}
	panic("Too many inodes in procfs!");
}

void
procfs_remove_inode(struct inode *inode) 
{
	//cprintf("procfs_remove_inode: %d\n", inode->inum);
	int i;
	for (i = 0; i < NINODE; i++) {
		if (inode_entries[i].used && inode_entries[i].inode == inode) {
			inode_entries[i].used = 0;
      inode_entries[i].inode = 0;
			return;
		}
	}
	panic("Failed to find inode in procfs_remove_inode!");
}

//-------------------------HELPERS---------------------------------------
char*
strcpy(char *s, const char *t)
{
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    ;
  return os;
}

int
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}

// convert int to string
void 
itoa(char s[], int n)
{
  int i=0, pm=n;
  int t, j;
  char c;
  
  if (pm < 0) {
    n = -n;          
  }
  do {       
    s[i++] = n % 10 + '0';   
  } while ((n /= 10) > 0);
  
  if (pm < 0) {
    s[i++] = '-';
  }
  s[i] = '\0';
  
  //reverse
  for (t = 0, j = strlen(s)-1; t<j; t++, j--) {
    c = s[t];
    s[t] = s[j];
    s[j] = c;
  }
} 
//--------------------------------------------------------
