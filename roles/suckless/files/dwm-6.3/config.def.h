/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int gappx     = 6;        /* gaps between windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "Terminus:size=10"};
static const char dmenufont[]       = "Terminus:size=13";
static const char col_black[]       = "#111315";
static const char col_gray[]       = "#bbbbbb";
static const char col_white[]       = "#eaebed";
static const char col_cyan[]        = "#005577";

static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray, col_black, col_black },
	[SchemeSel]  = { col_white, col_cyan,  col_cyan  },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 0; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define ALTKEY Mod1Mask
#define ALTGRKEY Mod5Mask

#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ ALTGRKEY,                    KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ ALTGRKEY|ShiftMask,          KEY,      toggletag,      {.ui = 1 << TAG} }, \

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-l", "30", "-fn", dmenufont, "-nb", col_black, "-nf", col_gray, "-sb", col_cyan, "-sf", col_white, NULL };
static const char *termcmd[]  = { "kitty", NULL };

#include "movestack.c"
#include <X11/XF86keysym.h>
static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_n,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
    { MODKEY,                       XK_w,      spawn,           SHCMD("firefox")},
    { MODKEY|ShiftMask,             XK_w,      spawn,           SHCMD("brave-browser")},
    { MODKEY,                       XK_f,      spawn,           SHCMD("st -e ~/.config/vifm/scripts/vifmrun")},
    { MODKEY|ShiftMask,             XK_f,      spawn,           SHCMD("pcmanfm")},
    { MODKEY|ShiftMask,             XK_s,      spawn,           SHCMD("flameshot gui -p ~/Downloads/screenshots")},
    { MODKEY|ShiftMask,             XK_m,      spawn,           SHCMD("~/.config/scripts/dmenu_scripts/dman")},
    { MODKEY|ShiftMask,             XK_a,      spawn,           SHCMD("~/.config/scripts/dmenu_scripts/dklay.sh")},
    { MODKEY|ShiftMask,             XK_x,      spawn,           SHCMD("~/.config/scripts/dmenu_scripts/dpower.sh")},
    { MODKEY|ShiftMask,             XK_d,      spawn,           SHCMD("~/.config/scripts/dmenu_scripts/ddown.sh")},
    { MODKEY|ShiftMask,             XK_v,      spawn,           SHCMD("~/.config/scripts/dmenu_scripts/dvid.sh")},
    { MODKEY,                       XK_o,      spawn,           SHCMD("~/.config/scripts/dmenu_scripts/dopen.sh")},
    { MODKEY|ShiftMask,             XK_l,      spawn,           SHCMD("slock")},
    { MODKEY|ShiftMask,             XK_t,      spawn,           SHCMD("st")},
    { MODKEY|ShiftMask,             XK_n,      spawn,           SHCMD("~/.config/scripts/networkmanager-dmenu/networkmanager_dmenu")},
    { MODKEY|ShiftMask,             XK_b,      spawn,           SHCMD("~/.config/scripts/dmenu_scripts/dmenu-bluetooth")},
    { MODKEY,                       XK_p,      spawn,           SHCMD("clipmenu -i -l 30")},
    { MODKEY,                       XK_bracketleft, spawn,      SHCMD("playerctl -p spotify previous")},
    { MODKEY,                       XK_bracketright, spawn,     SHCMD("playerctl -p spotify next")},
    { MODKEY,                       XK_grave,  spawn,           SHCMD("playerctl play-pause")},
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_j,      movestack,      {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_k,      movestack,      {.i = -1 } },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY|ControlMask,           XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
    {0, XF86XK_AudioMute, spawn, SHCMD("amixer set Master toggle")},
    {0, XF86XK_AudioRaiseVolume, spawn, SHCMD("amixer set Master 5%+")},
    {0, XF86XK_AudioLowerVolume, spawn, SHCMD("amixer set Master 5%-")},
    {0, XF86XK_AudioPrev, spawn, SHCMD("playerctl previous")},
    {0, XF86XK_AudioNext, spawn, SHCMD("playerctl next")},
    {0, XF86XK_AudioPlay, spawn, SHCMD("playerctl play-pause")},
    {0, XF86XK_AudioStop, spawn, SHCMD("playerctl stop")},
    {0, XF86XK_MonBrightnessUp, spawn, SHCMD("xbacklight -inc 10")},
    {0, XF86XK_MonBrightnessDown, spawn, SHCMD("xbacklight -dec 10")},
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};