#include<stdio.h>


int main() {

    FILE *fp, *fp_out;
    char buff[210000];

    fp_out = fopen("big_inputx.csv", "w");
    int i = 0;
    for(i=0;i<100;i++){
        fp = fopen("inputx.csv", "r");
        while(fgets(buff, 210000, (FILE*)fp) != NULL)
                fprintf(fp_out, "%s", buff);
        fclose(fp);
    }
    fclose(fp_out);

}
