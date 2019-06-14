#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

void read_line(char* path, char* name, int lineNum, int offset){
    char full_path[256];
	strcpy(full_path, path);
	strcpy(full_path + strlen(full_path), "/");
	strcpy(full_path + strlen(full_path), name);

	int fd = open(full_path, O_RDONLY);
	char data[256];
	read(fd, &data, 256);
	char *p = data;
    for(int i = 0; i < lineNum; i++){
        while (*p != '\n') {
            p++;
        }
        p++;
    }
    p--;
	*(++p) = '\0';
	printf(1, data+offset);
	close(fd);
}

void read_inode_file(char* path, char* name) {
	read_line(path, name, 1, 0);
    read_line(path, name, 2, 10);
    read_line(path, name, 3, 28);
    read_line(path, name, 4, 40);
    //read_line(path, name, 5, 10);
    //read_line(path, name, 6, 28);
    //read_line(path, name, 7, 28);
}

int
main(int argc, char *argv[]){
    char path[256];
	strcpy(path, "/proc");
	strcpy(path + strlen(path), "/inodeinfo");

	int fd = open(path, O_RDONLY);
	if (fd < 0) 
		printf(2, "Failed to open /proc/inodeinfo");

	struct dirent de = {0};
	while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0) 
        continue;
      
      if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0 || strcmp(de.name, "") == 0)
      	continue;

      read_inode_file(path, de.name);
    }

    close(fd);

	exit();
	return 0;
}