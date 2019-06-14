
_lsnd:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    //read_line(path, name, 6, 28);
    //read_line(path, name, 7, 28);
}

int
main(int argc, char *argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
    char path[256];
	strcpy(path, "/proc");
  11:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
main(int argc, char *argv[]){
  17:	81 ec 20 01 00 00    	sub    $0x120,%esp
	strcpy(path, "/proc");
  1d:	68 4a 09 00 00       	push   $0x94a
  22:	50                   	push   %eax
  23:	e8 28 02 00 00       	call   250 <strcpy>
	strcpy(path + strlen(path), "/inodeinfo");
  28:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  2e:	89 04 24             	mov    %eax,(%esp)
  31:	e8 9a 02 00 00       	call   2d0 <strlen>
  36:	8d 95 e8 fe ff ff    	lea    -0x118(%ebp),%edx
  3c:	59                   	pop    %ecx
  3d:	5b                   	pop    %ebx
  3e:	01 d0                	add    %edx,%eax
  40:	68 50 09 00 00       	push   $0x950
  45:	50                   	push   %eax
  46:	e8 05 02 00 00       	call   250 <strcpy>

	int fd = open(path, O_RDONLY);
  4b:	5e                   	pop    %esi
  4c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  52:	5f                   	pop    %edi
  53:	6a 00                	push   $0x0
  55:	50                   	push   %eax
  56:	e8 87 04 00 00       	call   4e2 <open>
	if (fd < 0) 
  5b:	83 c4 10             	add    $0x10,%esp
  5e:	85 c0                	test   %eax,%eax
	int fd = open(path, O_RDONLY);
  60:	89 c3                	mov    %eax,%ebx
	if (fd < 0) 
  62:	0f 88 be 00 00 00    	js     126 <main+0x126>
  68:	8d b5 d8 fe ff ff    	lea    -0x128(%ebp),%esi
	struct dirent de = {0};
	while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0) 
        continue;
      
      if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0 || strcmp(de.name, "") == 0)
  6e:	8d bd da fe ff ff    	lea    -0x126(%ebp),%edi
	struct dirent de = {0};
  74:	c7 85 d8 fe ff ff 00 	movl   $0x0,-0x128(%ebp)
  7b:	00 00 00 
  7e:	c7 85 dc fe ff ff 00 	movl   $0x0,-0x124(%ebp)
  85:	00 00 00 
  88:	c7 85 e0 fe ff ff 00 	movl   $0x0,-0x120(%ebp)
  8f:	00 00 00 
  92:	c7 85 e4 fe ff ff 00 	movl   $0x0,-0x11c(%ebp)
  99:	00 00 00 
  9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	while(read(fd, &de, sizeof(de)) == sizeof(de)){
  a0:	83 ec 04             	sub    $0x4,%esp
  a3:	6a 10                	push   $0x10
  a5:	56                   	push   %esi
  a6:	53                   	push   %ebx
  a7:	e8 0e 04 00 00       	call   4ba <read>
  ac:	83 c4 10             	add    $0x10,%esp
  af:	83 f8 10             	cmp    $0x10,%eax
  b2:	75 64                	jne    118 <main+0x118>
      if(de.inum == 0) 
  b4:	66 83 bd d8 fe ff ff 	cmpw   $0x0,-0x128(%ebp)
  bb:	00 
  bc:	74 e2                	je     a0 <main+0xa0>
      if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0 || strcmp(de.name, "") == 0)
  be:	83 ec 08             	sub    $0x8,%esp
  c1:	68 5c 09 00 00       	push   $0x95c
  c6:	57                   	push   %edi
  c7:	e8 b4 01 00 00       	call   280 <strcmp>
  cc:	83 c4 10             	add    $0x10,%esp
  cf:	85 c0                	test   %eax,%eax
  d1:	74 cd                	je     a0 <main+0xa0>
  d3:	83 ec 08             	sub    $0x8,%esp
  d6:	68 5b 09 00 00       	push   $0x95b
  db:	57                   	push   %edi
  dc:	e8 9f 01 00 00       	call   280 <strcmp>
  e1:	83 c4 10             	add    $0x10,%esp
  e4:	85 c0                	test   %eax,%eax
  e6:	74 b8                	je     a0 <main+0xa0>
  e8:	83 ec 08             	sub    $0x8,%esp
  eb:	68 86 09 00 00       	push   $0x986
  f0:	57                   	push   %edi
  f1:	e8 8a 01 00 00       	call   280 <strcmp>
  f6:	83 c4 10             	add    $0x10,%esp
  f9:	85 c0                	test   %eax,%eax
  fb:	74 a3                	je     a0 <main+0xa0>
      	continue;

      read_inode_file(path, de.name);
  fd:	50                   	push   %eax
  fe:	50                   	push   %eax
  ff:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
 105:	57                   	push   %edi
 106:	50                   	push   %eax
 107:	e8 f4 00 00 00       	call   200 <read_inode_file>
 10c:	83 c4 10             	add    $0x10,%esp
 10f:	eb 8f                	jmp    a0 <main+0xa0>
 111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }

    close(fd);
 118:	83 ec 0c             	sub    $0xc,%esp
 11b:	53                   	push   %ebx
 11c:	e8 a9 03 00 00       	call   4ca <close>

	exit();
 121:	e8 7c 03 00 00       	call   4a2 <exit>
		printf(2, "Failed to open /proc/inodeinfo");
 126:	52                   	push   %edx
 127:	52                   	push   %edx
 128:	68 60 09 00 00       	push   $0x960
 12d:	6a 02                	push   $0x2
 12f:	e8 bc 04 00 00       	call   5f0 <printf>
 134:	83 c4 10             	add    $0x10,%esp
 137:	e9 2c ff ff ff       	jmp    68 <main+0x68>
 13c:	66 90                	xchg   %ax,%ax
 13e:	66 90                	xchg   %ax,%ax

00000140 <read_line>:
void read_line(char* path, char* name, int lineNum, int offset){
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	57                   	push   %edi
 144:	56                   	push   %esi
 145:	53                   	push   %ebx
	strcpy(full_path, path);
 146:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
void read_line(char* path, char* name, int lineNum, int offset){
 14c:	81 ec 14 02 00 00    	sub    $0x214,%esp
	strcpy(full_path, path);
 152:	ff 75 08             	pushl  0x8(%ebp)
void read_line(char* path, char* name, int lineNum, int offset){
 155:	8b 75 10             	mov    0x10(%ebp),%esi
	strcpy(full_path, path);
 158:	53                   	push   %ebx
 159:	e8 f2 00 00 00       	call   250 <strcpy>
	strcpy(full_path + strlen(full_path), "/");
 15e:	89 1c 24             	mov    %ebx,(%esp)
 161:	e8 6a 01 00 00       	call   2d0 <strlen>
 166:	5a                   	pop    %edx
 167:	59                   	pop    %ecx
 168:	01 d8                	add    %ebx,%eax
 16a:	68 48 09 00 00       	push   $0x948
 16f:	50                   	push   %eax
 170:	e8 db 00 00 00       	call   250 <strcpy>
	strcpy(full_path + strlen(full_path), name);
 175:	89 1c 24             	mov    %ebx,(%esp)
 178:	e8 53 01 00 00       	call   2d0 <strlen>
 17d:	5f                   	pop    %edi
 17e:	5a                   	pop    %edx
 17f:	01 d8                	add    %ebx,%eax
 181:	ff 75 0c             	pushl  0xc(%ebp)
 184:	50                   	push   %eax
 185:	e8 c6 00 00 00       	call   250 <strcpy>
	int fd = open(full_path, O_RDONLY);
 18a:	59                   	pop    %ecx
 18b:	5f                   	pop    %edi
 18c:	6a 00                	push   $0x0
 18e:	53                   	push   %ebx
	read(fd, &data, 256);
 18f:	8d bd e8 fe ff ff    	lea    -0x118(%ebp),%edi
	int fd = open(full_path, O_RDONLY);
 195:	e8 48 03 00 00       	call   4e2 <open>
	read(fd, &data, 256);
 19a:	83 c4 0c             	add    $0xc,%esp
	int fd = open(full_path, O_RDONLY);
 19d:	89 c3                	mov    %eax,%ebx
	read(fd, &data, 256);
 19f:	68 00 01 00 00       	push   $0x100
 1a4:	57                   	push   %edi
 1a5:	50                   	push   %eax
 1a6:	e8 0f 03 00 00       	call   4ba <read>
    for(int i = 0; i < lineNum; i++){
 1ab:	83 c4 10             	add    $0x10,%esp
 1ae:	31 d2                	xor    %edx,%edx
 1b0:	85 f6                	test   %esi,%esi
	char *p = data;
 1b2:	89 f8                	mov    %edi,%eax
    for(int i = 0; i < lineNum; i++){
 1b4:	7f 0d                	jg     1c3 <read_line+0x83>
 1b6:	eb 1a                	jmp    1d2 <read_line+0x92>
 1b8:	90                   	nop
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            p++;
 1c0:	83 c0 01             	add    $0x1,%eax
        while (*p != '\n') {
 1c3:	80 38 0a             	cmpb   $0xa,(%eax)
 1c6:	75 f8                	jne    1c0 <read_line+0x80>
    for(int i = 0; i < lineNum; i++){
 1c8:	83 c2 01             	add    $0x1,%edx
        p++;
 1cb:	83 c0 01             	add    $0x1,%eax
    for(int i = 0; i < lineNum; i++){
 1ce:	39 d6                	cmp    %edx,%esi
 1d0:	75 f1                	jne    1c3 <read_line+0x83>
	printf(1, data+offset);
 1d2:	03 7d 14             	add    0x14(%ebp),%edi
 1d5:	83 ec 08             	sub    $0x8,%esp
	*(++p) = '\0';
 1d8:	c6 00 00             	movb   $0x0,(%eax)
	printf(1, data+offset);
 1db:	57                   	push   %edi
 1dc:	6a 01                	push   $0x1
 1de:	e8 0d 04 00 00       	call   5f0 <printf>
	close(fd);
 1e3:	89 1c 24             	mov    %ebx,(%esp)
 1e6:	e8 df 02 00 00       	call   4ca <close>
}
 1eb:	83 c4 10             	add    $0x10,%esp
 1ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1f1:	5b                   	pop    %ebx
 1f2:	5e                   	pop    %esi
 1f3:	5f                   	pop    %edi
 1f4:	5d                   	pop    %ebp
 1f5:	c3                   	ret    
 1f6:	8d 76 00             	lea    0x0(%esi),%esi
 1f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000200 <read_inode_file>:
void read_inode_file(char* path, char* name) {
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	56                   	push   %esi
 204:	53                   	push   %ebx
 205:	8b 75 0c             	mov    0xc(%ebp),%esi
 208:	8b 5d 08             	mov    0x8(%ebp),%ebx
	read_line(path, name, 1, 0);
 20b:	6a 00                	push   $0x0
 20d:	6a 01                	push   $0x1
 20f:	56                   	push   %esi
 210:	53                   	push   %ebx
 211:	e8 2a ff ff ff       	call   140 <read_line>
    read_line(path, name, 2, 10);
 216:	6a 0a                	push   $0xa
 218:	6a 02                	push   $0x2
 21a:	56                   	push   %esi
 21b:	53                   	push   %ebx
 21c:	e8 1f ff ff ff       	call   140 <read_line>
    read_line(path, name, 3, 28);
 221:	83 c4 20             	add    $0x20,%esp
 224:	6a 1c                	push   $0x1c
 226:	6a 03                	push   $0x3
 228:	56                   	push   %esi
 229:	53                   	push   %ebx
 22a:	e8 11 ff ff ff       	call   140 <read_line>
    read_line(path, name, 4, 40);
 22f:	6a 28                	push   $0x28
 231:	6a 04                	push   $0x4
 233:	56                   	push   %esi
 234:	53                   	push   %ebx
 235:	e8 06 ff ff ff       	call   140 <read_line>
}
 23a:	83 c4 20             	add    $0x20,%esp
 23d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 240:	5b                   	pop    %ebx
 241:	5e                   	pop    %esi
 242:	5d                   	pop    %ebp
 243:	c3                   	ret    
 244:	66 90                	xchg   %ax,%ax
 246:	66 90                	xchg   %ax,%ax
 248:	66 90                	xchg   %ax,%ax
 24a:	66 90                	xchg   %ax,%ax
 24c:	66 90                	xchg   %ax,%ax
 24e:	66 90                	xchg   %ax,%ax

00000250 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 25a:	89 c2                	mov    %eax,%edx
 25c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 260:	83 c1 01             	add    $0x1,%ecx
 263:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 267:	83 c2 01             	add    $0x1,%edx
 26a:	84 db                	test   %bl,%bl
 26c:	88 5a ff             	mov    %bl,-0x1(%edx)
 26f:	75 ef                	jne    260 <strcpy+0x10>
    ;
  return os;
}
 271:	5b                   	pop    %ebx
 272:	5d                   	pop    %ebp
 273:	c3                   	ret    
 274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 27a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000280 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	53                   	push   %ebx
 284:	8b 55 08             	mov    0x8(%ebp),%edx
 287:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 28a:	0f b6 02             	movzbl (%edx),%eax
 28d:	0f b6 19             	movzbl (%ecx),%ebx
 290:	84 c0                	test   %al,%al
 292:	75 1c                	jne    2b0 <strcmp+0x30>
 294:	eb 2a                	jmp    2c0 <strcmp+0x40>
 296:	8d 76 00             	lea    0x0(%esi),%esi
 299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 2a0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 2a3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 2a6:	83 c1 01             	add    $0x1,%ecx
 2a9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 2ac:	84 c0                	test   %al,%al
 2ae:	74 10                	je     2c0 <strcmp+0x40>
 2b0:	38 d8                	cmp    %bl,%al
 2b2:	74 ec                	je     2a0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 2b4:	29 d8                	sub    %ebx,%eax
}
 2b6:	5b                   	pop    %ebx
 2b7:	5d                   	pop    %ebp
 2b8:	c3                   	ret    
 2b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2c0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 2c2:	29 d8                	sub    %ebx,%eax
}
 2c4:	5b                   	pop    %ebx
 2c5:	5d                   	pop    %ebp
 2c6:	c3                   	ret    
 2c7:	89 f6                	mov    %esi,%esi
 2c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002d0 <strlen>:

uint
strlen(const char *s)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 2d6:	80 39 00             	cmpb   $0x0,(%ecx)
 2d9:	74 15                	je     2f0 <strlen+0x20>
 2db:	31 d2                	xor    %edx,%edx
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
 2e0:	83 c2 01             	add    $0x1,%edx
 2e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2e7:	89 d0                	mov    %edx,%eax
 2e9:	75 f5                	jne    2e0 <strlen+0x10>
    ;
  return n;
}
 2eb:	5d                   	pop    %ebp
 2ec:	c3                   	ret    
 2ed:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 2f0:	31 c0                	xor    %eax,%eax
}
 2f2:	5d                   	pop    %ebp
 2f3:	c3                   	ret    
 2f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000300 <memset>:

void*
memset(void *dst, int c, uint n)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	57                   	push   %edi
 304:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 307:	8b 4d 10             	mov    0x10(%ebp),%ecx
 30a:	8b 45 0c             	mov    0xc(%ebp),%eax
 30d:	89 d7                	mov    %edx,%edi
 30f:	fc                   	cld    
 310:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 312:	89 d0                	mov    %edx,%eax
 314:	5f                   	pop    %edi
 315:	5d                   	pop    %ebp
 316:	c3                   	ret    
 317:	89 f6                	mov    %esi,%esi
 319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000320 <strchr>:

char*
strchr(const char *s, char c)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	53                   	push   %ebx
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 32a:	0f b6 10             	movzbl (%eax),%edx
 32d:	84 d2                	test   %dl,%dl
 32f:	74 1d                	je     34e <strchr+0x2e>
    if(*s == c)
 331:	38 d3                	cmp    %dl,%bl
 333:	89 d9                	mov    %ebx,%ecx
 335:	75 0d                	jne    344 <strchr+0x24>
 337:	eb 17                	jmp    350 <strchr+0x30>
 339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 340:	38 ca                	cmp    %cl,%dl
 342:	74 0c                	je     350 <strchr+0x30>
  for(; *s; s++)
 344:	83 c0 01             	add    $0x1,%eax
 347:	0f b6 10             	movzbl (%eax),%edx
 34a:	84 d2                	test   %dl,%dl
 34c:	75 f2                	jne    340 <strchr+0x20>
      return (char*)s;
  return 0;
 34e:	31 c0                	xor    %eax,%eax
}
 350:	5b                   	pop    %ebx
 351:	5d                   	pop    %ebp
 352:	c3                   	ret    
 353:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000360 <gets>:

char*
gets(char *buf, int max)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
 365:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 366:	31 f6                	xor    %esi,%esi
 368:	89 f3                	mov    %esi,%ebx
{
 36a:	83 ec 1c             	sub    $0x1c,%esp
 36d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 370:	eb 2f                	jmp    3a1 <gets+0x41>
 372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 378:	8d 45 e7             	lea    -0x19(%ebp),%eax
 37b:	83 ec 04             	sub    $0x4,%esp
 37e:	6a 01                	push   $0x1
 380:	50                   	push   %eax
 381:	6a 00                	push   $0x0
 383:	e8 32 01 00 00       	call   4ba <read>
    if(cc < 1)
 388:	83 c4 10             	add    $0x10,%esp
 38b:	85 c0                	test   %eax,%eax
 38d:	7e 1c                	jle    3ab <gets+0x4b>
      break;
    buf[i++] = c;
 38f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 393:	83 c7 01             	add    $0x1,%edi
 396:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 399:	3c 0a                	cmp    $0xa,%al
 39b:	74 23                	je     3c0 <gets+0x60>
 39d:	3c 0d                	cmp    $0xd,%al
 39f:	74 1f                	je     3c0 <gets+0x60>
  for(i=0; i+1 < max; ){
 3a1:	83 c3 01             	add    $0x1,%ebx
 3a4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3a7:	89 fe                	mov    %edi,%esi
 3a9:	7c cd                	jl     378 <gets+0x18>
 3ab:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 3ad:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 3b0:	c6 03 00             	movb   $0x0,(%ebx)
}
 3b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3b6:	5b                   	pop    %ebx
 3b7:	5e                   	pop    %esi
 3b8:	5f                   	pop    %edi
 3b9:	5d                   	pop    %ebp
 3ba:	c3                   	ret    
 3bb:	90                   	nop
 3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3c0:	8b 75 08             	mov    0x8(%ebp),%esi
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	01 de                	add    %ebx,%esi
 3c8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 3ca:	c6 03 00             	movb   $0x0,(%ebx)
}
 3cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3d0:	5b                   	pop    %ebx
 3d1:	5e                   	pop    %esi
 3d2:	5f                   	pop    %edi
 3d3:	5d                   	pop    %ebp
 3d4:	c3                   	ret    
 3d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	56                   	push   %esi
 3e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e5:	83 ec 08             	sub    $0x8,%esp
 3e8:	6a 00                	push   $0x0
 3ea:	ff 75 08             	pushl  0x8(%ebp)
 3ed:	e8 f0 00 00 00       	call   4e2 <open>
  if(fd < 0)
 3f2:	83 c4 10             	add    $0x10,%esp
 3f5:	85 c0                	test   %eax,%eax
 3f7:	78 27                	js     420 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3f9:	83 ec 08             	sub    $0x8,%esp
 3fc:	ff 75 0c             	pushl  0xc(%ebp)
 3ff:	89 c3                	mov    %eax,%ebx
 401:	50                   	push   %eax
 402:	e8 f3 00 00 00       	call   4fa <fstat>
  close(fd);
 407:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 40a:	89 c6                	mov    %eax,%esi
  close(fd);
 40c:	e8 b9 00 00 00       	call   4ca <close>
  return r;
 411:	83 c4 10             	add    $0x10,%esp
}
 414:	8d 65 f8             	lea    -0x8(%ebp),%esp
 417:	89 f0                	mov    %esi,%eax
 419:	5b                   	pop    %ebx
 41a:	5e                   	pop    %esi
 41b:	5d                   	pop    %ebp
 41c:	c3                   	ret    
 41d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 420:	be ff ff ff ff       	mov    $0xffffffff,%esi
 425:	eb ed                	jmp    414 <stat+0x34>
 427:	89 f6                	mov    %esi,%esi
 429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000430 <atoi>:

int
atoi(const char *s)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	53                   	push   %ebx
 434:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 437:	0f be 11             	movsbl (%ecx),%edx
 43a:	8d 42 d0             	lea    -0x30(%edx),%eax
 43d:	3c 09                	cmp    $0x9,%al
  n = 0;
 43f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 444:	77 1f                	ja     465 <atoi+0x35>
 446:	8d 76 00             	lea    0x0(%esi),%esi
 449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 450:	8d 04 80             	lea    (%eax,%eax,4),%eax
 453:	83 c1 01             	add    $0x1,%ecx
 456:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 45a:	0f be 11             	movsbl (%ecx),%edx
 45d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 460:	80 fb 09             	cmp    $0x9,%bl
 463:	76 eb                	jbe    450 <atoi+0x20>
  return n;
}
 465:	5b                   	pop    %ebx
 466:	5d                   	pop    %ebp
 467:	c3                   	ret    
 468:	90                   	nop
 469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000470 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	56                   	push   %esi
 474:	53                   	push   %ebx
 475:	8b 5d 10             	mov    0x10(%ebp),%ebx
 478:	8b 45 08             	mov    0x8(%ebp),%eax
 47b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 47e:	85 db                	test   %ebx,%ebx
 480:	7e 14                	jle    496 <memmove+0x26>
 482:	31 d2                	xor    %edx,%edx
 484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 488:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 48c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 48f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 492:	39 d3                	cmp    %edx,%ebx
 494:	75 f2                	jne    488 <memmove+0x18>
  return vdst;
}
 496:	5b                   	pop    %ebx
 497:	5e                   	pop    %esi
 498:	5d                   	pop    %ebp
 499:	c3                   	ret    

0000049a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 49a:	b8 01 00 00 00       	mov    $0x1,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <exit>:
SYSCALL(exit)
 4a2:	b8 02 00 00 00       	mov    $0x2,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <wait>:
SYSCALL(wait)
 4aa:	b8 03 00 00 00       	mov    $0x3,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <pipe>:
SYSCALL(pipe)
 4b2:	b8 04 00 00 00       	mov    $0x4,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <read>:
SYSCALL(read)
 4ba:	b8 05 00 00 00       	mov    $0x5,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <write>:
SYSCALL(write)
 4c2:	b8 10 00 00 00       	mov    $0x10,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <close>:
SYSCALL(close)
 4ca:	b8 15 00 00 00       	mov    $0x15,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <kill>:
SYSCALL(kill)
 4d2:	b8 06 00 00 00       	mov    $0x6,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <exec>:
SYSCALL(exec)
 4da:	b8 07 00 00 00       	mov    $0x7,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <open>:
SYSCALL(open)
 4e2:	b8 0f 00 00 00       	mov    $0xf,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <mknod>:
SYSCALL(mknod)
 4ea:	b8 11 00 00 00       	mov    $0x11,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <unlink>:
SYSCALL(unlink)
 4f2:	b8 12 00 00 00       	mov    $0x12,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <fstat>:
SYSCALL(fstat)
 4fa:	b8 08 00 00 00       	mov    $0x8,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <link>:
SYSCALL(link)
 502:	b8 13 00 00 00       	mov    $0x13,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <mkdir>:
SYSCALL(mkdir)
 50a:	b8 14 00 00 00       	mov    $0x14,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <chdir>:
SYSCALL(chdir)
 512:	b8 09 00 00 00       	mov    $0x9,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <dup>:
SYSCALL(dup)
 51a:	b8 0a 00 00 00       	mov    $0xa,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <getpid>:
SYSCALL(getpid)
 522:	b8 0b 00 00 00       	mov    $0xb,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <sbrk>:
SYSCALL(sbrk)
 52a:	b8 0c 00 00 00       	mov    $0xc,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <sleep>:
SYSCALL(sleep)
 532:	b8 0d 00 00 00       	mov    $0xd,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <uptime>:
SYSCALL(uptime)
 53a:	b8 0e 00 00 00       	mov    $0xe,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    
 542:	66 90                	xchg   %ax,%ax
 544:	66 90                	xchg   %ax,%ax
 546:	66 90                	xchg   %ax,%ax
 548:	66 90                	xchg   %ax,%ax
 54a:	66 90                	xchg   %ax,%ax
 54c:	66 90                	xchg   %ax,%ax
 54e:	66 90                	xchg   %ax,%ax

00000550 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	57                   	push   %edi
 554:	56                   	push   %esi
 555:	53                   	push   %ebx
 556:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 559:	85 d2                	test   %edx,%edx
{
 55b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 55e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 560:	79 76                	jns    5d8 <printint+0x88>
 562:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 566:	74 70                	je     5d8 <printint+0x88>
    x = -xx;
 568:	f7 d8                	neg    %eax
    neg = 1;
 56a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 571:	31 f6                	xor    %esi,%esi
 573:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 576:	eb 0a                	jmp    582 <printint+0x32>
 578:	90                   	nop
 579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 580:	89 fe                	mov    %edi,%esi
 582:	31 d2                	xor    %edx,%edx
 584:	8d 7e 01             	lea    0x1(%esi),%edi
 587:	f7 f1                	div    %ecx
 589:	0f b6 92 88 09 00 00 	movzbl 0x988(%edx),%edx
  }while((x /= base) != 0);
 590:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 592:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 595:	75 e9                	jne    580 <printint+0x30>
  if(neg)
 597:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 59a:	85 c0                	test   %eax,%eax
 59c:	74 08                	je     5a6 <printint+0x56>
    buf[i++] = '-';
 59e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 5a3:	8d 7e 02             	lea    0x2(%esi),%edi
 5a6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 5aa:	8b 7d c0             	mov    -0x40(%ebp),%edi
 5ad:	8d 76 00             	lea    0x0(%esi),%esi
 5b0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 5b3:	83 ec 04             	sub    $0x4,%esp
 5b6:	83 ee 01             	sub    $0x1,%esi
 5b9:	6a 01                	push   $0x1
 5bb:	53                   	push   %ebx
 5bc:	57                   	push   %edi
 5bd:	88 45 d7             	mov    %al,-0x29(%ebp)
 5c0:	e8 fd fe ff ff       	call   4c2 <write>

  while(--i >= 0)
 5c5:	83 c4 10             	add    $0x10,%esp
 5c8:	39 de                	cmp    %ebx,%esi
 5ca:	75 e4                	jne    5b0 <printint+0x60>
    putc(fd, buf[i]);
}
 5cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5cf:	5b                   	pop    %ebx
 5d0:	5e                   	pop    %esi
 5d1:	5f                   	pop    %edi
 5d2:	5d                   	pop    %ebp
 5d3:	c3                   	ret    
 5d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5d8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5df:	eb 90                	jmp    571 <printint+0x21>
 5e1:	eb 0d                	jmp    5f0 <printf>
 5e3:	90                   	nop
 5e4:	90                   	nop
 5e5:	90                   	nop
 5e6:	90                   	nop
 5e7:	90                   	nop
 5e8:	90                   	nop
 5e9:	90                   	nop
 5ea:	90                   	nop
 5eb:	90                   	nop
 5ec:	90                   	nop
 5ed:	90                   	nop
 5ee:	90                   	nop
 5ef:	90                   	nop

000005f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	57                   	push   %edi
 5f4:	56                   	push   %esi
 5f5:	53                   	push   %ebx
 5f6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5f9:	8b 75 0c             	mov    0xc(%ebp),%esi
 5fc:	0f b6 1e             	movzbl (%esi),%ebx
 5ff:	84 db                	test   %bl,%bl
 601:	0f 84 b3 00 00 00    	je     6ba <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 607:	8d 45 10             	lea    0x10(%ebp),%eax
 60a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 60d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 60f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 612:	eb 2f                	jmp    643 <printf+0x53>
 614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 618:	83 f8 25             	cmp    $0x25,%eax
 61b:	0f 84 a7 00 00 00    	je     6c8 <printf+0xd8>
  write(fd, &c, 1);
 621:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 624:	83 ec 04             	sub    $0x4,%esp
 627:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 62a:	6a 01                	push   $0x1
 62c:	50                   	push   %eax
 62d:	ff 75 08             	pushl  0x8(%ebp)
 630:	e8 8d fe ff ff       	call   4c2 <write>
 635:	83 c4 10             	add    $0x10,%esp
 638:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 63b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 63f:	84 db                	test   %bl,%bl
 641:	74 77                	je     6ba <printf+0xca>
    if(state == 0){
 643:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 645:	0f be cb             	movsbl %bl,%ecx
 648:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 64b:	74 cb                	je     618 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 64d:	83 ff 25             	cmp    $0x25,%edi
 650:	75 e6                	jne    638 <printf+0x48>
      if(c == 'd'){
 652:	83 f8 64             	cmp    $0x64,%eax
 655:	0f 84 05 01 00 00    	je     760 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 65b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 661:	83 f9 70             	cmp    $0x70,%ecx
 664:	74 72                	je     6d8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 666:	83 f8 73             	cmp    $0x73,%eax
 669:	0f 84 99 00 00 00    	je     708 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 66f:	83 f8 63             	cmp    $0x63,%eax
 672:	0f 84 08 01 00 00    	je     780 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 678:	83 f8 25             	cmp    $0x25,%eax
 67b:	0f 84 ef 00 00 00    	je     770 <printf+0x180>
  write(fd, &c, 1);
 681:	8d 45 e7             	lea    -0x19(%ebp),%eax
 684:	83 ec 04             	sub    $0x4,%esp
 687:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 68b:	6a 01                	push   $0x1
 68d:	50                   	push   %eax
 68e:	ff 75 08             	pushl  0x8(%ebp)
 691:	e8 2c fe ff ff       	call   4c2 <write>
 696:	83 c4 0c             	add    $0xc,%esp
 699:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 69c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 69f:	6a 01                	push   $0x1
 6a1:	50                   	push   %eax
 6a2:	ff 75 08             	pushl  0x8(%ebp)
 6a5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6a8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 6aa:	e8 13 fe ff ff       	call   4c2 <write>
  for(i = 0; fmt[i]; i++){
 6af:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 6b3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6b6:	84 db                	test   %bl,%bl
 6b8:	75 89                	jne    643 <printf+0x53>
    }
  }
}
 6ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6bd:	5b                   	pop    %ebx
 6be:	5e                   	pop    %esi
 6bf:	5f                   	pop    %edi
 6c0:	5d                   	pop    %ebp
 6c1:	c3                   	ret    
 6c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 6c8:	bf 25 00 00 00       	mov    $0x25,%edi
 6cd:	e9 66 ff ff ff       	jmp    638 <printf+0x48>
 6d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 6d8:	83 ec 0c             	sub    $0xc,%esp
 6db:	b9 10 00 00 00       	mov    $0x10,%ecx
 6e0:	6a 00                	push   $0x0
 6e2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6e5:	8b 45 08             	mov    0x8(%ebp),%eax
 6e8:	8b 17                	mov    (%edi),%edx
 6ea:	e8 61 fe ff ff       	call   550 <printint>
        ap++;
 6ef:	89 f8                	mov    %edi,%eax
 6f1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6f4:	31 ff                	xor    %edi,%edi
        ap++;
 6f6:	83 c0 04             	add    $0x4,%eax
 6f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6fc:	e9 37 ff ff ff       	jmp    638 <printf+0x48>
 701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 708:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 70b:	8b 08                	mov    (%eax),%ecx
        ap++;
 70d:	83 c0 04             	add    $0x4,%eax
 710:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 713:	85 c9                	test   %ecx,%ecx
 715:	0f 84 8e 00 00 00    	je     7a9 <printf+0x1b9>
        while(*s != 0){
 71b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 71e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 720:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 722:	84 c0                	test   %al,%al
 724:	0f 84 0e ff ff ff    	je     638 <printf+0x48>
 72a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 72d:	89 de                	mov    %ebx,%esi
 72f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 732:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 735:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 738:	83 ec 04             	sub    $0x4,%esp
          s++;
 73b:	83 c6 01             	add    $0x1,%esi
 73e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 741:	6a 01                	push   $0x1
 743:	57                   	push   %edi
 744:	53                   	push   %ebx
 745:	e8 78 fd ff ff       	call   4c2 <write>
        while(*s != 0){
 74a:	0f b6 06             	movzbl (%esi),%eax
 74d:	83 c4 10             	add    $0x10,%esp
 750:	84 c0                	test   %al,%al
 752:	75 e4                	jne    738 <printf+0x148>
 754:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 757:	31 ff                	xor    %edi,%edi
 759:	e9 da fe ff ff       	jmp    638 <printf+0x48>
 75e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 760:	83 ec 0c             	sub    $0xc,%esp
 763:	b9 0a 00 00 00       	mov    $0xa,%ecx
 768:	6a 01                	push   $0x1
 76a:	e9 73 ff ff ff       	jmp    6e2 <printf+0xf2>
 76f:	90                   	nop
  write(fd, &c, 1);
 770:	83 ec 04             	sub    $0x4,%esp
 773:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 776:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 779:	6a 01                	push   $0x1
 77b:	e9 21 ff ff ff       	jmp    6a1 <printf+0xb1>
        putc(fd, *ap);
 780:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 783:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 786:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 788:	6a 01                	push   $0x1
        ap++;
 78a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 78d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 790:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 793:	50                   	push   %eax
 794:	ff 75 08             	pushl  0x8(%ebp)
 797:	e8 26 fd ff ff       	call   4c2 <write>
        ap++;
 79c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 79f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7a2:	31 ff                	xor    %edi,%edi
 7a4:	e9 8f fe ff ff       	jmp    638 <printf+0x48>
          s = "(null)";
 7a9:	bb 80 09 00 00       	mov    $0x980,%ebx
        while(*s != 0){
 7ae:	b8 28 00 00 00       	mov    $0x28,%eax
 7b3:	e9 72 ff ff ff       	jmp    72a <printf+0x13a>
 7b8:	66 90                	xchg   %ax,%ax
 7ba:	66 90                	xchg   %ax,%ax
 7bc:	66 90                	xchg   %ax,%ax
 7be:	66 90                	xchg   %ax,%ax

000007c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c1:	a1 8c 0c 00 00       	mov    0xc8c,%eax
{
 7c6:	89 e5                	mov    %esp,%ebp
 7c8:	57                   	push   %edi
 7c9:	56                   	push   %esi
 7ca:	53                   	push   %ebx
 7cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7ce:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 7d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d8:	39 c8                	cmp    %ecx,%eax
 7da:	8b 10                	mov    (%eax),%edx
 7dc:	73 32                	jae    810 <free+0x50>
 7de:	39 d1                	cmp    %edx,%ecx
 7e0:	72 04                	jb     7e6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e2:	39 d0                	cmp    %edx,%eax
 7e4:	72 32                	jb     818 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7e9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7ec:	39 fa                	cmp    %edi,%edx
 7ee:	74 30                	je     820 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7f0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7f3:	8b 50 04             	mov    0x4(%eax),%edx
 7f6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7f9:	39 f1                	cmp    %esi,%ecx
 7fb:	74 3a                	je     837 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7fd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 7ff:	a3 8c 0c 00 00       	mov    %eax,0xc8c
}
 804:	5b                   	pop    %ebx
 805:	5e                   	pop    %esi
 806:	5f                   	pop    %edi
 807:	5d                   	pop    %ebp
 808:	c3                   	ret    
 809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 810:	39 d0                	cmp    %edx,%eax
 812:	72 04                	jb     818 <free+0x58>
 814:	39 d1                	cmp    %edx,%ecx
 816:	72 ce                	jb     7e6 <free+0x26>
{
 818:	89 d0                	mov    %edx,%eax
 81a:	eb bc                	jmp    7d8 <free+0x18>
 81c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 820:	03 72 04             	add    0x4(%edx),%esi
 823:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 826:	8b 10                	mov    (%eax),%edx
 828:	8b 12                	mov    (%edx),%edx
 82a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 82d:	8b 50 04             	mov    0x4(%eax),%edx
 830:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 833:	39 f1                	cmp    %esi,%ecx
 835:	75 c6                	jne    7fd <free+0x3d>
    p->s.size += bp->s.size;
 837:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 83a:	a3 8c 0c 00 00       	mov    %eax,0xc8c
    p->s.size += bp->s.size;
 83f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 842:	8b 53 f8             	mov    -0x8(%ebx),%edx
 845:	89 10                	mov    %edx,(%eax)
}
 847:	5b                   	pop    %ebx
 848:	5e                   	pop    %esi
 849:	5f                   	pop    %edi
 84a:	5d                   	pop    %ebp
 84b:	c3                   	ret    
 84c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000850 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	57                   	push   %edi
 854:	56                   	push   %esi
 855:	53                   	push   %ebx
 856:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 859:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 85c:	8b 15 8c 0c 00 00    	mov    0xc8c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 862:	8d 78 07             	lea    0x7(%eax),%edi
 865:	c1 ef 03             	shr    $0x3,%edi
 868:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 86b:	85 d2                	test   %edx,%edx
 86d:	0f 84 9d 00 00 00    	je     910 <malloc+0xc0>
 873:	8b 02                	mov    (%edx),%eax
 875:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 878:	39 cf                	cmp    %ecx,%edi
 87a:	76 6c                	jbe    8e8 <malloc+0x98>
 87c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 882:	bb 00 10 00 00       	mov    $0x1000,%ebx
 887:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 88a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 891:	eb 0e                	jmp    8a1 <malloc+0x51>
 893:	90                   	nop
 894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 898:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 89a:	8b 48 04             	mov    0x4(%eax),%ecx
 89d:	39 f9                	cmp    %edi,%ecx
 89f:	73 47                	jae    8e8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a1:	39 05 8c 0c 00 00    	cmp    %eax,0xc8c
 8a7:	89 c2                	mov    %eax,%edx
 8a9:	75 ed                	jne    898 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 8ab:	83 ec 0c             	sub    $0xc,%esp
 8ae:	56                   	push   %esi
 8af:	e8 76 fc ff ff       	call   52a <sbrk>
  if(p == (char*)-1)
 8b4:	83 c4 10             	add    $0x10,%esp
 8b7:	83 f8 ff             	cmp    $0xffffffff,%eax
 8ba:	74 1c                	je     8d8 <malloc+0x88>
  hp->s.size = nu;
 8bc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8bf:	83 ec 0c             	sub    $0xc,%esp
 8c2:	83 c0 08             	add    $0x8,%eax
 8c5:	50                   	push   %eax
 8c6:	e8 f5 fe ff ff       	call   7c0 <free>
  return freep;
 8cb:	8b 15 8c 0c 00 00    	mov    0xc8c,%edx
      if((p = morecore(nunits)) == 0)
 8d1:	83 c4 10             	add    $0x10,%esp
 8d4:	85 d2                	test   %edx,%edx
 8d6:	75 c0                	jne    898 <malloc+0x48>
        return 0;
  }
}
 8d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8db:	31 c0                	xor    %eax,%eax
}
 8dd:	5b                   	pop    %ebx
 8de:	5e                   	pop    %esi
 8df:	5f                   	pop    %edi
 8e0:	5d                   	pop    %ebp
 8e1:	c3                   	ret    
 8e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8e8:	39 cf                	cmp    %ecx,%edi
 8ea:	74 54                	je     940 <malloc+0xf0>
        p->s.size -= nunits;
 8ec:	29 f9                	sub    %edi,%ecx
 8ee:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8f1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8f4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 8f7:	89 15 8c 0c 00 00    	mov    %edx,0xc8c
}
 8fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 900:	83 c0 08             	add    $0x8,%eax
}
 903:	5b                   	pop    %ebx
 904:	5e                   	pop    %esi
 905:	5f                   	pop    %edi
 906:	5d                   	pop    %ebp
 907:	c3                   	ret    
 908:	90                   	nop
 909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 910:	c7 05 8c 0c 00 00 90 	movl   $0xc90,0xc8c
 917:	0c 00 00 
 91a:	c7 05 90 0c 00 00 90 	movl   $0xc90,0xc90
 921:	0c 00 00 
    base.s.size = 0;
 924:	b8 90 0c 00 00       	mov    $0xc90,%eax
 929:	c7 05 94 0c 00 00 00 	movl   $0x0,0xc94
 930:	00 00 00 
 933:	e9 44 ff ff ff       	jmp    87c <malloc+0x2c>
 938:	90                   	nop
 939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 940:	8b 08                	mov    (%eax),%ecx
 942:	89 0a                	mov    %ecx,(%edx)
 944:	eb b1                	jmp    8f7 <malloc+0xa7>
