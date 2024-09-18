#include <iostream>

int main(int,char**)
{
 std::cout << "unsigned long long " << sizeof(unsigned long long) << "\n";
 std::cout << "unsigned long long int " << sizeof(unsigned long long int) << "\n";
//  std::cout << "u_int_t " << sizeof(u_int128_t) << "\n";
 std::cout << "unsigned char " << sizeof(unsigned char) << "\n";
 return 0;
}