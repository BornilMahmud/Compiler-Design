#include <stdio.h>

int main() {
    int n;

    printf("Enter number of elements: ");
    scanf("%d", &n);

    int arr[n];

    printf("Enter elements:\n");
    for(int i = 0; i < n; i++) {
        scanf("%d", &arr[i]);
    }

    int max = arr[0];
    int second = -999999;

    for(int i = 1; i < n; i++) {
        if(arr[i] > max) {
            max = arr[i];
        }
    }

    for(int i = 0; i < n; i++) {
        if(arr[i] > second && arr[i] < max) {
            second = arr[i];
        }
    }

    if(second == -999999)
        printf("No second highest number found\n");
    else
        printf("Second highest number = %d\n", second);

    return 0;
}