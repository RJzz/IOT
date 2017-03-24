
#ifndef FIND_H
#define FIND_H

enum {
  AM_TEST_SERIAL_MSG = 0x89
};

typedef nx_struct DataMsg {
	nx_uint16_t node_id;
}DataMsg;

//serial 
typedef nx_struct Serialmsg {
         //nx_uint16_t  0xFFFF
  nx_uint16_t node_id; 
} Serialmsg;
#endif