#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

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
    read(fd, o, 512);
    
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
        if(cur[0] != 0){
            printf(1,"%s > ", cur);
        }
    }
    printf(1,"\n");
    close(fd);
}


int
main(int argc, char *argv[]){   
	int fd = open("/proc/inodeinfo", O_RDONLY);
	if (fd < 0){ 
		printf(2, "Failed to open /proc/inodeinfo\n");
    }

	struct dirent de = {0};
	while(read(fd, &de, sizeof(de)) == sizeof(de)){
        if(de.inum == 0){
            continue;
        }
        if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
            continue;
        }
        //printf(1,"name: %s\n", de.name);
        read_inodeinfo("/proc/inodeinfo", de.name);
    }

    close(fd);
	exit();
	return 0;
}