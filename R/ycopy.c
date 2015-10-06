#include<stdio.h>


int main() {

    FILE *fp, *fp_out;
    char buff[50];

    fp_out = fopen("input.csv.100g", "w");
    int i = 0;
    for(i=0;i<100;i++){
        fp = fopen("input.csv.ten", "r");
        while(fgets(buff, 50, (FILE*)fp) != NULL)
                fprintf(fp_out, "%s", buff);
        fclose(fp);
    }
    fclose(fp_out);

}
