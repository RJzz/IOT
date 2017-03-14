COMPONENT=FindC
CFLAGS += -DCC2420_DEF_RFPOWER=1 
CFLAGS += -DCC2420_DEF_CHANNEL=18
CFLAGS += -I$(TOSDIR)/lib/printf \
		  -I$(TOSDIR)/lib/net \
          -I$(TOSDIR)/lib/net/le \
          -I$(TOSDIR)/lib/net/ctp
include $(MAKERULES)