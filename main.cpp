#include <stdio.h>
#include <iostream>
#include <iomanip>
#include "json.hpp"
#include <string>
#include <fstream>
#include <vector>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <unistd.h>
#include "utils/inet.h"
// #include "utils/Json.h"

using namespace std;
using nlohmann::json;


#define IP ((in_addr_t)0xc0a80168)
#define SERVER_PORT 6789
#define BUFF_LEN 1024

void SplitStringToVector( vector<string> &vecStr, string strSource, string strSplit, int nSkip = 0 )
{
	vector<string>::size_type sPos = nSkip;
	vector<string>::size_type ePos = strSource.find( strSplit, sPos );
	while( ePos != string::npos )
	{
		if( sPos != ePos ) vecStr.push_back( strSource.substr( sPos, ePos - sPos ) );
		sPos = ePos + strSplit.size();    
		ePos = strSource.find( strSplit, sPos );
	}    
	if( sPos < strSource.size() ) vecStr.push_back( strSource.substr( sPos, strSource.size() - sPos ) ); 
}
//agent from moos
void handle_udp_msg(int fd)
{
    char buf[BUFF_LEN];  //接收缓冲区，1024字节
    socklen_t len;
    int count;
    string data;

    json device;
    json myjson;
    json j3;
    json j2;

    vector<string> vecStr;
    
    struct sockaddr_in clent_addr;  //clent_addr用于记录发送方的地址信息
    while(1)
    {
        memset(buf, 0, BUFF_LEN);
        len = sizeof(clent_addr);
        count = recvfrom(fd, buf, BUFF_LEN, 0, (struct sockaddr*)&clent_addr, &len);  //recvfrom是拥塞函数，没有数据就一直拥塞
        if(count == -1)
        {
            printf("recieve data fail!\n");
            return;
        }
        data = buf;
        cout << data << endl; //打印client发过来的信息
        SplitStringToVector( vecStr, data, "\r\n");
        for( vector<string>::iterator iter = vecStr.begin(); iter != vecStr.end(); iter++ ){
            cout<<*iter<<endl;
            j2 = json::parse(*iter);
            j3.push_back(j2["param"]);
            cout << "---j3---"<<j3 << endl;
        }
        device["cmd"] = "notify_status";
        device["param"] = j3;

        std::ofstream o("pretty.json");
        o << std::setw(4) << device << std::endl;

        vector<string>().swap(vecStr);
        j3.clear();


        //sprintf(buf, "I have recieved %d bytes data!\n", count);  //回复client

        printf("server:%s\n",buf);  //打印自己发送的信息给
        sendto(fd, buf, BUFF_LEN, 0, (struct sockaddr*)&clent_addr, len);  //发送信息给client，注意使用了clent_addr结构体指针
        memset(buf, 0, BUFF_LEN);
    }
}


/*
    server:
            socket-->bind-->recvfrom-->sendto-->close
*/

int main(int argc, char* argv[])
{

    int server_fd, ret;
    struct sockaddr_in ser_addr;

    server_fd = socket(AF_INET, SOCK_DGRAM, 0); //AF_INET:IPV4;SOCK_DGRAM:UDP
    if(server_fd < 0)
    {
        printf("create socket fail!\n");
        return -1;
    }

    memset(&ser_addr, 0, sizeof(ser_addr));
    ser_addr.sin_family = AF_INET;
    ser_addr.sin_addr.s_addr = inet_addr("192.168.1.104"); //IP地址，需要进行网络序转换，INADDR_ANY：本地地址
    ser_addr.sin_port = htons(SERVER_PORT);  //端口号，需要网络序转换

    ret = bind(server_fd, (struct sockaddr*)&ser_addr, sizeof(ser_addr));
    if(ret < 0)
    {
        printf("socket bind fail!\n");
        return -1;
    }

    handle_udp_msg(server_fd);   //处理接收到的数据

    close(server_fd);
    return 0;
}