#include<stdio.h>


int main() {

    FILE *fp, *fp_out;
    char buff[50];

    fp_out = fopen("input.csv", "w");
    int i = 0;
    for(i=0;i<20;i++){
        fp = fopen("input.csv.five", "r");
        while(fgets(buff, 50, (FILE*)fp) != NULL)
                fprintf(fp_out, "%s", buff);
        fclose(fp);
    }
    fclose(fp_out);

}
