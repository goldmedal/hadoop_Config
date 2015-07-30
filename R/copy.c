#include<stdio.h>


int main() {

    FILE *fp, *fp_out;
    char buff[210000];

    fp_out = fopen("inputx.csv", "w");
    int i = 0;
    for(i=0;i<20;i++){
        fp = fopen("inputx.csv.five", "r");
        while(fgets(buff, 210000, (FILE*)fp) != NULL)
                fprintf(fp_out, "%s", buff);
        fclose(fp);
    }
    fclose(fp_out);

}
