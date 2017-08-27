## Programming

### C

```
/* very simple program that decodes base64 data from file that is passed as first argument
 usage: ./main mydata 
*/
#include  // guchar * g_base64_decode_inplace (gchar *text, gsize *out_len); ... under centos: packages: glib2 and glib2-devel
#include  // for strlen() etc
#include  // FILE
#include  // for exit() function 
#define BUFFERSIZE 100000
int main(int argc, char* argv[])
{
printf("reading %s\n",argv[1]);
FILE* file;
gsize myout_len; //The length of the decoded data is written here.
char myMegaBuffer[BUFFERSIZE];
size_t numberofbytesread;
file=fopen(argv[1], "r");
numberofbytesread=fread(myMegaBuffer,sizeof(char),BUFFERSIZE,file);
g_base64_decode_inplace( (gchar *)myMegaBuffer, (gsize *)&myout_len);
myMegaBuffer[myout_len]='\0';
printf("%s\n", myMegaBuffer);
exit(0);
}
/*
suggested Makefile:

all: main

main: main.o
	gcc -v -o main main.o -lglib-2.0

main.o: main.c
	gcc -c -I/usr/include/glib-2.0/ -I/usr/lib/x86_64-linux-gnu/glib-2.0/include/ main.c

clean:
	rm -f main.o main
*/
```

