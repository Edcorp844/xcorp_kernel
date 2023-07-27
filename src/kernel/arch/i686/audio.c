#include "audio.h"
#include <arch/i686/io.h>

static void play_sound(uint32_t nFrequence) {
 	uint32_t Div;
 	uint8_t tmp;
 
   //Set the PIT to the desired frequency
 	Div = 1193180 / nFrequence;
 	i686_outb(0x43, 0xb6);
 	i686_outb(0x42, (uint8_t) (Div) );
 	i686_outb(0x42, (uint8_t) (Div >> 8));
 
   //And play the sound using the PC speaker
 	tmp = i686_inb(0x61);
  	if (tmp != (tmp | 3)) {
 		i686_outb(0x61, tmp | 3);
 	}
}
 
 //make it shutup
static void nosound() {
   uint8_t tmp = i686_inb(0x61) & 0xFC;
 
   i686_outb(0x61, tmp);
}
 
 //Make a beep
 void beep() {
 	play_sound(1000);
 	timer_wait(10);
 	nosound();
   //set_PIT_2(old_frequency);
 }