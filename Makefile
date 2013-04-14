PRG     = rfbee

SRC     = main.c serial.c serial_fifo.c spi.c rfBeeSerial.c rfBeeCore.c ccx.c config.c

MCU     = atmega168
LDFLAGS += -L/usr/avr/lib/avr5/

OPT     = s
DEFS    = -DF_CPU=8000000 -DDEBUG

CC      = avr-gcc
SIZE    = avr-size

CFLAGS  = -std=c99 -Winline -Wall -O$(OPT) -mmcu=$(MCU) $(DEFS)
#$(SMPL_INC)

OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump

OBJS    = $(addsuffix .o,$(basename $(SRC)))

all: hex
	$(SIZE) $(PRG).elf

$(PRG).elf: $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)

$(OBJS): %.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(OBJS) $(PRG).elf $(PRG).hex

hex:  $(PRG).hex

%.hex: %.elf
	$(OBJCOPY) -j .text -j .data -O ihex $< $@

upload: $(PRG).hex
	avrdude -c arduino -P /dev/ttyUSB0 -b 19200 -p $(MCU) -U flash:w:$(PRG).hex

monitor:
	screen /dev/ttyUSB0 9600
