#include<iostream>
#include<fstream>
#include<string>
#include<iomanip>
using namespace std;

int main()
{
    char para[3] = { 0 };

    for (int i = 0;; i++)
    {
        cin >> para;

        if (para[0] == 'z')
            break;

        cout << "assign weight[" << i << "] = 8'h" << para << ';' << endl;
    }


    return 0;
}
