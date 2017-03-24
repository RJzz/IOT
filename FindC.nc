configuration FindC {
}

implementation {
	components FindM, MainC, ActiveMessageC;
	components CollectionC as Collector;
	components new CollectionSenderC(0xee);
	components new TimerMilliC() as T0;
	components new TimerMilliC() as T1;
	
	FindM.Boot -> MainC;
	FindM.RadioControl -> ActiveMessageC;
	FindM.RoutingControl -> Collector;
	FindM.Timer0 ->T0;
	FindM.Timer1 ->T1;
	FindM.Send -> CollectionSenderC;
	FindM.RootControl -> Collector;
	FindM.Receive -> Collector.Receive[0xee];
	
	components SerialActiveMessageC as AM;
	FindM.serialControl -> AM;
	FindM.serialReceive -> AM.Receive[AM_TEST_SERIAL_MSG];
	FindM.serialAMSend -> AM.AMSend[AM_TEST_SERIAL_MSG];
	FindM.serialPacket -> AM;
}