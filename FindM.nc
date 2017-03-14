#include <Timer.h>
#include "Find.h"
#include "printf.h"
module FindM {
	uses interface Boot;
	uses interface SplitControl as RadioControl;
	uses interface StdControl as RoutingControl;
	uses interface Send;
	uses interface Leds;
	uses interface Timer<TMilli>;
	uses interface RootControl;
	uses interface Receive;
}

implementation {
	message_t packet;
	
	bool sendBusy = FALSE;
	bool sendSuccess = FALSE;
	
	//最大节点ID
	uint16_t max_node_id = 0;
	
	//最小节点ID
	uint16_t min_node_id = 0;
	
	
	//收到的ID个数
	uint16_t node_count = 0;
	
	event void Boot.booted() {
		call RadioControl.start();
	}
	
	
	event void RadioControl.startDone(error_t err) {
		//如果没有成功则再次开启
		if(err != SUCCESS) {
			call RadioControl.start();
		}else {
			call RoutingControl.start();
			//将id为0的节点设置为根节点
			if(TOS_NODE_ID == 0) {
				call RootControl.setRoot();
			}else {//如果不是根节点则启动定时器，准备向根节点发送自己的ID号
				call Timer.startOneShot(2000);
			}
		}
	}
	
	event void RadioControl.stopDone(error_t err) {}
	
	void sendMessage() {
		DataMsg *msg = (DataMsg* )call Send.getPayload(&packet, sizeof(DataMsg));	
		
		msg->node_id = TOS_NODE_ID;
		
		if(call Send.send(&packet, sizeof(DataMsg)) != SUCCESS) {
		    printf("Node: %d Send Failed\n", TOS_NODE_ID);
			printfflush();
		}else {
			sendBusy = TRUE;
		}
	}
	
	//定时器到，发送消息
	event void Timer.fired() {
		printf("Timer Fired Node: %d Sending\n", TOS_NODE_ID);
		printfflush();
		if(!sendBusy) {
			sendMessage();
		}
	}
	
	//发送结束
	event void Send.sendDone(message_t * m, error_t err) {
		if(err != SUCCESS) {
			printf("Node: %d Send Failed\n", TOS_NODE_ID);
			printfflush();
		}else {
			sendSuccess = TRUE;
		}
		sendBusy = FALSE;
	}
	
	//0号根节点接收数据
	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		DataMsg* receive = (DataMsg*)payload;
		if(len == sizeof(DataMsg)) {
			if(receive->node_id > max_node_id) {
				max_node_id = receive->node_id;
			}
			if(receive->node_id < min_node_id) {
				min_node_id = receive->node_id;
			}
			node_count++;
			//收到了其余所有49个节点的id号
			if(node_count == 49) {
				printf("Max Node is %d\t Min Node is %d", max_node_id, min_node_id);
				printfflush();
			}
		}else {
			printf("Receive an error packet");
			printfflush();
		}
	}
}