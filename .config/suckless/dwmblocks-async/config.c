#include "config.h"
#include "block.h"
#include "util.h"

/*
 Click numbers:
 1 = Left
 2 = Middle
 3 = Right
 4 = Scroll Up
 5 = Scroll Down
*/

Block blocks[] = {
    { "/home/ayush/.config/suckless/dwmblocks-async/scripts/s_spotify",  1,  1 },
    { "/home/ayush/.config/suckless/dwmblocks-async/scripts/s_cmus",     1,  2 },
    { "/home/ayush/.config/suckless/dwmblocks-async/scripts/s_weather", 600, 16 },
    
    { "/home/ayush/.config/suckless/dwmblocks-async/scripts/s_cpu",      5, 10 },
    { "/home/ayush/.config/suckless/dwmblocks-async/scripts/s_mem",      5, 11 },
    { "/home/ayush/.config/suckless/dwmblocks-async/scripts/s_temp",    10, 12 },
    { "/home/ayush/.config/suckless/dwmblocks-async/scripts/s_battery", 30, 13 },
    { "/home/ayush/.config/suckless/dwmblocks-async/scripts/s_hdd",   1800,14 },

    { "/home/ayush/.config/suckless/dwmblocks-async/scripts/s_net",     1, 15 },
    { "/home/ayush/.config/suckless/dwmblocks-async/scripts/s_vol",      0,  7 },
    { "/home/ayush/.config/suckless/dwmblocks-async/scripts/s_date",    60,  6 },
};


const unsigned short blockCount = LEN(blocks);
