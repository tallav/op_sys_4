#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

/*void read_line(char* path, char* name, int lineNum, int offset){
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
    read_line(path, name, 5, 50);
   // read_line(path, name, 6, 60);
   // read_line(path, name, 7, 70);
}
*/

void read_inodeinfo(char* path, char* ind){
    char full_path[256];
	strcpy(full_path, path);
	strcpy(full_path + strlen(full_path), "/");
	strcpy(full_path + strlen(full_path), ind);
    int fd = open(full_path, O_RDONLY);
    if (fd < 0){
        printf(1,"failed to open file, path: %s\n",path);
    }

    char data[512] = {0};
    char *o = (char*)&data;
    int off = 16;
    int l = read(fd, o, 16);
    while (l>0){
        l = read(fd, o+off, 16);
        off = off + l;
    }

    for (int i=0; i<512; i++){
        char cur[100] = {0};
        int j = 0;
        if ((char)*(o + i) == (char)':'){
            char c = '\0';
            i++;
            printf(1,"<");

            while(c!='\n'){
                c = data[i];
                if (c!=(char)'\n'){
                    cur[j] = data[i];
                }
                j++;
                i++;
            }
        }
        printf(1,"%s ", cur);
        printf(1, ">");
    }
    printf(1,"\n");
    close(fd);
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

      read_inodeinfo(path, de.name);
    }

    close(fd);

	exit();
	return 0;
}