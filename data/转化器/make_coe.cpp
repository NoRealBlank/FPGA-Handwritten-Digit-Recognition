#include<iostream>
#include<fstream>
#include<string>
#include<iomanip>
using namespace std;

int main()
{
    ifstream in("9.mp3", ios::in | ios::binary);
    ofstream out("9.coe", ios::out | ios::binary);

    out << "MEMORY_INITIALIZATION_RADIX=16;\n";
    out << "MEMORY_INITIALIZATION_VECTOR=\n";

    unsigned int temp;
    while (!in.eof())
    {
        in.read(((char*)&temp + 3), 1);
        in.read(((char*)&temp + 2), 1);
        in.read(((char*)&temp + 1), 1);
        in.read(((char*)&temp), 1);

        out << setfill('0') << setw(8) << hex << temp;
        out << (in.eof() ? ';' : ',') << endl;
    }

    in.close();
    out.close();

    return 0;
}
