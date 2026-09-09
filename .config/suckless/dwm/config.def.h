/* ===================== APPEARANCE ===================== */
/* Window border width and pixel distance used before windows snap to edges. */
static unsigned int borderpx = 2;
static unsigned int snap = 0;

/* Default gaps: inner horizontal/vertical, then outer horizontal/vertical. */
static const unsigned int gappih = 10;
static const unsigned int gappiv = 10;
static const unsigned int gappoh = 10;
static const unsigned int gappov = 10;

/* smartgaps removes outer gaps when only one tiled client is visible. */
static int smartgaps = 0;
static const int swallowfloating = 0;

/* Bar visibility and placement: showbar=1 enables it, topbar=1 puts it at top. */
static int showbar = 1;
static int topbar = 1;

/* slop styles are used by rio-style interactive draw/resize helpers. */
static const char slopspawnstyle[]  = "-t 0 -c 0.92,0.85,0.69,0.3 -o";
static const char slopresizestyle[] = "-t 0 -c 0.92,0.85,0.69,0.3";

static const int riodraw_borders = 0;
static const int riodraw_spawnasync = 0;

static const int user_bh = 12;
static const int vertpad = 10;
static const int sidepad = 10;

/* Enable the window-map patch, which can show clients hidden/minimized by dwm. */
static const int windowmap = 1;

/* Tag preview scaling and whether previews include the bar. */
static const int scalepreview = 6;
static const int previewbar = 0;

static const char buttonbar[] = "";

#define HIDEVACANT 0
#define ICONSIZE 10
#define ICONSPACING 5

/* First font handles text/icons; second font provides emoji fallback. */
static const char *fonts[] = {
    "JetBrainsMono Nerd Font:style=Bold:size=11:antialias=true:autohint=true",
    "Noto Color Emoji:size=11"
};

/* ===================== TOKYO NIGHT ===================== */

static const char col_bg[]         = "#1a1b26";
static const char col_fg[]         = "#c0caf5";
static const char col_border[]     = "#414868";

static const char col_sel_bg[]     = "#24283b";
static const char col_sel_fg[]     = "#7aa2f7";
static const char col_sel_border[] = "#7aa2f7";

static const char col_hid_fg[]     = "#565f89";

/* Color schemes used by normal, selected, and hidden clients. */
static const char *colors[][3] = {
    /*               fg            bg            border */
    [SchemeNorm] = { col_fg,       col_bg,       col_border },
    [SchemeSel]  = { col_sel_fg,   col_sel_bg,   col_sel_border },
    [SchemeHid]  = { col_hid_fg,   col_bg,       col_border },
};

/* Alpha values are foreground, background, and border for each color scheme. */
static const unsigned int baralpha    = 0xDD;
static const unsigned int borderalpha = OPAQUE;

static const unsigned int alphas[][3] = {
    [SchemeNorm] = { OPAQUE, baralpha, borderalpha },
    [SchemeSel]  = { OPAQUE, baralpha, borderalpha },
    [SchemeHid]  = { OPAQUE, baralpha, borderalpha },
};

/* Small polygon drawn on sticky clients in the bar. */
static const XPoint stickyicon[] = {
    {0,0},{4,0},{4,8},{2,6},{0,8},{0,0}
};

static const XPoint stickyiconbb = {4,8};

/* ===================== SCRATCHPADS ===================== */

typedef struct {
    const char *name;
    const void *cmd;
} Sp;

/* Scratchpads are floating windows hidden on special tags outside the normal 1-9 tags. */
const char *spcmd1[] = {"kitty", "--title", "spterm", NULL};

static Sp scratchpads[] = {
    {"spterm",spcmd1},
};

/* ===================== TAGS ===================== */

/* The three tag arrays draw empty, occupied, and selected tag states. */
static const char *tags[] = {
    "","","","","",
    "","","",""
};

static const char *alttags[] = {
    "","","","","",
    "","","",""
};

static const char *selectedtags[] = {
    "","","","","",
    "","","",""
};

/* Underline patch settings for the tag bar. */
static const unsigned int ulinepad = 5;
static const unsigned int ulinestroke = 0;
static const unsigned int ulinevoffset = 0;
static const int ulineall = 0;

/* ===================== RULES ===================== */

static const Rule rules[] = {

    /*
     * Rule fields:
     * class, instance, title, tags, iscentered, isfloating, isterminal,
     * noswallow, monitor, float x/y/w/h, floating border width.
     * Use -1 for "default/current monitor" or "leave geometry unchanged".
     */
    { "St", NULL, NULL, 0, 1, 0, 1, 0, -1, -1, -1, -1, -1, -1 },

    /* Match scratchpads by their st -n instance name and keep them floating. */
    { NULL, NULL, "spterm",  SPTAG(0), 1, 1, 0, 0, -1, 400, 150, 1200, 800, -1 },
};
   
/* ===================== LAYOUT ===================== */

/* Default master area size, number of master clients, and size-hint behavior. */
static float mfact = 0.50;
static int nmaster = 1;
static int resizehints = 0;

/* attachdirection=3 attaches new clients below the selected client. */
static const int attachdirection = 3;
static const int lockfullscreen = 1;

/* Vanitygaps provides the tiled layouts and gap controls below. */
#define FORCE_VSPLIT 1
#include "vanitygaps.c"

static const Layout layouts[] = {
    {"󱍸", spiral},
    {NULL, NULL},
};

/* ===================== KEYS ===================== */

#define MODKEY Mod4Mask

#define TAGKEYS(KEY,TAG) \
    { MODKEY,                       KEY, view,       {.ui = 1 << TAG} }, \
    { MODKEY|ShiftMask,            KEY, tag,        {.ui = 1 << TAG} },

#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

#define STATUSBAR "dwmblocks"

/* ===================== COMMANDS ===================== */

static char dmenumon[2] = "0";

/* Kept for dwm's spawn monitor logic; this config launches rofi directly instead. */
static const char *dmenucmd[] = { NULL };

static const char *termcmd[] = {"kitty",NULL};
static const char *browser[] = {"brave",NULL};
static const char *roficmd[] = {"rofi","-show","drun",NULL};
static const char *filecmd[] = {"thunar",NULL};

static const char *flameshotcmd[] = {
    "sh","-c",
    "flameshot gui",
    NULL
};

static const char *layoutmenu_cmd = "layoutmenu.sh";

static const char *lockcmd[] = {"slock", NULL};

static const char *clipcmd[] = {
    "rofi",
    "-modi",
    "clipboard:greenclip print",
    "-show",
    "clipboard",
    NULL
};

static const char *wifi[] = {
    "sh",
    "-c",
    "$HOME/.config/scripts/wifi",
    NULL
};

static const char *wallpapercmd[] = {
    "sh",
    "-c",
    "$HOME/.config/wallchanger/rofi-wallpaper.sh",
    NULL
};

static const char *recordcmd[] = {
    "sh",
    "-c",
    "$HOME/.config/scripts/screen-record-and-stop.sh",
    NULL
};

/* Rofi window switcher with thumbnails - like Windows Alt+Tab */
static const char *rofiwindow[] = {
    "rofi",
    "-show",
    "window",
    "-window-thumbnail",
    NULL
};

#include "movestack.c"
#include "exitdwm.c"

#include <X11/XF86keysym.h>

/* ===================== KEYBINDINGS ===================== */

static const Key keys[] = {

    /* apps and launchers */
    { MODKEY, XK_b, spawn, {.v = browser} },
    { MODKEY, XK_d, spawn, {.v = roficmd} },
    { MODKEY, XK_f, spawn, {.v = filecmd} },
    { MODKEY, XK_p, spawn, {.v = flameshotcmd} },

    /* recording */
    { MODKEY, XK_r, spawn, {.v = recordcmd } },

    /* wifi */
    { MODKEY, XK_w, spawn, {.v = wifi} },

    /* wallpaper */
    { MODKEY|ShiftMask, XK_w, spawn, {.v = wallpapercmd } },
    
    /* terminal */
    { MODKEY, XK_Return, spawn, {.v = termcmd} },

    /* scratchpads - only spterm on mod+grave */
    { MODKEY, XK_grave, togglescratch, {.ui = 0} },

    /* Rofi window switcher with previews (like Windows Alt+Tab) */
    { MODKEY, XK_Tab, spawn, {.v = rofiwindow} },

    /* volume */
    { 0, XF86XK_AudioMute,
        spawn, SHCMD("pamixer -t; pkill -RTMIN+7 dwmblocks") },

    { 0, XF86XK_AudioLowerVolume,
        spawn, SHCMD("pamixer -d 5; pkill -RTMIN+7 dwmblocks") },

    { 0, XF86XK_AudioRaiseVolume,
        spawn, SHCMD("pamixer -i 5; pkill -RTMIN+7 dwmblocks") },

    /* brightness */
    { 0, XF86XK_MonBrightnessUp,
        spawn, SHCMD("brightnessctl set +5%") },

    { 0, XF86XK_MonBrightnessDown,
        spawn, SHCMD("brightnessctl set 5%-") },

    /* navigation */
    { MODKEY, XK_j, focusstackvis, {.i = +1} },
    { MODKEY, XK_k, focusstackvis, {.i = -1} },

    /* gaps */
    { MODKEY, XK_g, togglegaps, {0} },
    { MODKEY, XK_minus, incrgaps, {.i = -5} },
    { MODKEY, XK_equal, incrgaps, {.i = +5} },

    /* resize */
    { MODKEY, XK_h, setmfact, {.f = -0.05} },
    { MODKEY, XK_l, setmfact, {.f = +0.05} },

    /* bar */
    { MODKEY|ShiftMask, XK_b, togglebar, {0} },

    /* layouts and window state */
    { MODKEY|ShiftMask, XK_d, incnmaster, {.i = -1} },
    /* Layout switching removed - only spiral layout available */
    { MODKEY|ShiftMask, XK_f, togglefullscr, {0} },
    { MODKEY, XK_space, togglefloating, {0} },

    /* lock */
    { MODKEY|ShiftMask, XK_x, spawn, {.v = lockcmd} },

    /* restart dwm */
    { MODKEY|ControlMask, XK_r, quit, {1} },

    /* kill client */
    { MODKEY|ShiftMask, XK_q, killclient, {0} },

    TAGKEYS(XK_1,0)
    TAGKEYS(XK_2,1)
    TAGKEYS(XK_3,2)
    TAGKEYS(XK_4,3)
    TAGKEYS(XK_5,4)
    TAGKEYS(XK_6,5)
    TAGKEYS(XK_7,6)
    TAGKEYS(XK_8,7)
    TAGKEYS(XK_9,8)
};

/* ===================== BUTTONS ===================== */

static const Button buttons[] = {

    /* move/resize */
    { ClkClientWin, MODKEY, Button1, movemouse,   {0} },
    { ClkClientWin, MODKEY, Button3, resizemouse, {0} },

    /* tags */
    { ClkTagBar, 0, Button1, view,       {0} },
    { ClkTagBar, 0, Button3, toggleview, {0} },

    { ClkTagBar, 0, Button4, view, {.ui = -1} },
    { ClkTagBar, 0, Button5, view, {.ui = +1} },

    /* layout - removed switching since only one layout exists */
    { ClkLtSymbol, 0, Button1, {0} },
    { ClkLtSymbol, 0, Button3, {0} },

    /* title */
    { ClkWinTitle, 0, Button2, zoom, {0} },

    /* statusbar */
    { ClkStatusText, 0, Button1, sigstatusbar, {.i = 1} },
    { ClkStatusText, 0, Button2, sigstatusbar, {.i = 2} },
    { ClkStatusText, 0, Button3, sigstatusbar, {.i = 3} },
    { ClkStatusText, 0, Button4, sigstatusbar, {.i = 4} },
    { ClkStatusText, 0, Button5, sigstatusbar, {.i = 5} },
};