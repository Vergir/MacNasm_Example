#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

void PrintFloat(float a)
{
    printf("\n%f\n", a);
    return;
}

void PrintHeader()
{
    puts("|  x   | ser. |   c  | iter |");
    return;
}

void PrintTableEntry(float x0, float result, float iterations)
{
	float c = logf((x0 + 1) / (1 - x0));
    printf("| %4.2f | %4.2f | %4.2f | %4.0f |\n", x0, result, c, iterations);
    return;
}

int GetIntFromConsole(int min, int max, char * msg)
{
    char * buffer = malloc(sizeof(char)*255);
    int ch;
    unsigned short strlen;
    
    puts(msg);
    
    while (1)
    {
        strlen = 0;
        ch = getchar();
        while (ch != EOF && ch != '\n')
        {
            buffer[strlen++] = ch;
            ch = getchar();
        }
        buffer[strlen] = '\0';
        if (sscanf(buffer, "%i", &ch) > 0 && ch >= min && ch <= max)
            break;
        puts("Invalid input. Please try again");
    }
    free(buffer);
    return ch;
}
double GetFloatFromConsole(float min, float max, char * msg)
{
    char * buffer = malloc(sizeof(char)*255);
    int ch;
    float result;
    unsigned short strlen;
    
    puts(msg);
    
    while (1)
    {
        strlen = 0;
        ch = getchar();
        while (ch != EOF && ch != '\n')
        {
            buffer[strlen++] = ch;
            ch = getchar();
        }
        buffer[strlen] = '\0';
        if (sscanf(buffer, "%f", &result) > 0 && result >= min && result <= max)
            return result;
        puts("\nInvalid input. Please try again");
    }
    free(buffer);
    
}

