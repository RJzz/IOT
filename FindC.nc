configuration FindC {
}

implementation {
	components FindM, MainC, ActiveMessageC;
	components CollectionC as Collector;
	components new CollectionSenderC(0xee);
	components new TimerMilliC();
	
	FindM.Boot -> MainC;
	FindM.RadioControl -> ActiveMessageC;
	FindM.RoutingControl -> Collector;
	FindM.Timer ->TimerMilliC;
	FindM.Send -> CollectionSenderC;
	FindM.RootControl -> Collector;
	FindM.Receive -> Collector.Receive[0xee];
	
	
}