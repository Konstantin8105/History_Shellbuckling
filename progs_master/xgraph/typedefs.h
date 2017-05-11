
/*  --------------------------------------  */
/*  the following typedefs are given FIRST  */
/*  since others below depend upon them     */
/*  --------------------------------------  */

/*  from ( xtb.h )  */
/*  --------------  */

typedef void *         xtb_data;

typedef enum xtb_hret_defn { /* Handler function return codes */
    XTB_NOTDEF,
    XTB_HANDLED,
    XTB_STOP
} xtb_hret;

/*  from ( xtb.c )  */
/*  --------------  */

typedef struct b_info_defn {
    xtb_hret (*func) (Window win,
                      int    state,
                      xtb_data val); /* Function to call */
    char      *text;                 /* Text of button   */
    int        flag;                 /* State of button  */
    int        na;                   /* Non-zero if not active */
    int        line_y;               /* Entry/Exit line  */
    int        line_w;               /* Entry/Exit line  */
    xtb_data   val;                  /* User defined info */
} b_info;

typedef struct ti_info_defn {
    xtb_hret (*func) (Window    win,
                      int       ch,
                      char     *textcopy,
                      xtb_data  val);    /* Function to call   */
    int        maxlen;                   /* Maximum characters */
    int        curidx;                   /* Current index pos  */
    int        curxval;                  /* Current draw loc   */
    char       text[MAXCHBUF];           /* Current text array */
    int        line_y;                   /* Entry/Exit line    */
    int        line_w;                   /* Entry/Exit line    */
    int        focus_flag;               /* If on, we have focus */
    xtb_data   val;                      /* User info          */
} ti_info;

typedef struct to_info_defn {
    char        *text;    /* Text to display */
    XFontStruct *ft;      /* Font to use     */
} to_info;


/*  ------------------------------------  */
/*  now define all of the other typedefs  */
/*  ------------------------------------  */


/*  from ( alloc.c )  */
/*  ----------------  */

typedef void *  Ptr;

/*  from ( dialog.c )  */
/*  -----------------  */

typedef struct d_info_defn {
    char     *prog;	 /* Program name             */
    xtb_data  cookie;	 /* Info used by do_harcopy  */
    Window    choices;	 /* Output device choices    */
    Window    fod;	 /* File or device flag      */
    Window    fodspec;	 /* File or device spec      */
    Window    docu_p;	 /* Document predicate       */
    Window    dimspec;	 /* Maximum dimension spec   */
    Window    outfmt;    /* Output format choices    */
    Window    tf_family; /* Title font family spec   */
    Window    tf_size;	 /* Title font size spec     */
    Window    af_family; /* Axis font family spec    */
    Window    af_size;	 /* Axis font size spec      */
} d_info;

/*  from ( hard_devices.h )  */
/*  -----------------------  */

typedef enum hard_dev_docu_defn {
    NONE,
    NO,
    YES
} hard_dev_docu;

typedef struct hard_dev_defn {
    char   *dev_name;		    /* Device name                       */
    int   (*dev_init) ();	    /* Initialization function           */
    char   *dev_spec;		    /* Default pipe program              */
    char    dev_file[MFNAME];	    /* Default file name                 */
    char    dev_printer[MFNAME];    /* Default printer name              */
    double  dev_max_width;	    /* Default maximum width  (cm)       */
    double  dev_max_height;	    /* Default maximum height (cm)       */
    char    dev_title_font[MFNAME]; /* Default name of title font        */
    double  dev_title_size;	    /* Default size of title font (pnts) */
    char    dev_axis_font[MFNAME];  /* Default name of axis font         */
    double  dev_axis_size;	    /* Default size of axis font (pnts)  */
    hard_dev_docu dev_docu;	    /* Document predicate                */
} hard_dev;

/*  from ( hpgl.c )  */
/*  ---------------  */

typedef struct {
    double  axis_w;
    double  axis_h;
    double  title_w;
    double  title_h;
    FILE   *plotterFile;
    int     clipminX;
    int     clipminY;
    int     clipmaxX;
    int     clipmaxY;
} mydata;

/*  from ( idraw.c ) & ( tgif.c )  */
/*  -----------------------------  */

typedef struct {
    char   *title_font;
    char   *axis_font;
    int     title_size;
    int     axis_size;
    FILE   *strm;
} Info;

/*  from ( params.h )  */
/*  -----------------  */

typedef enum param_types_defn {
    INT,
    STR,
    PIXEL,
    FONT,
    STYLE,
    BOOL,
    DBL
} param_types;

typedef struct params_int_defn {
    param_types type;		/* INT */
    int         value;
} param_int;

typedef struct params_str_defn {
    param_types type;		/* STR */
    char       *value;
} param_str;

typedef struct params_pix_defn {
    param_types type;		/* PIXEL */
    XColor      value;
} param_pix;

typedef struct params_font_defn {
    param_types  type;		/* FONT */
    XFontStruct *value;
} param_font;

typedef struct params_style_defn {
    param_types type;		/* STYLE */
    int         len;
    char       *dash_list;
} param_style;

typedef struct params_bool_defn {
    param_types type;		/* BOOL */
    int         value;
} param_bool;

typedef struct params_dbl_defn {
    param_types type;		/* DBL */
    double      value;
} param_dbl;

typedef union params_defn {
    param_types type;
    param_int   intv;   /* INT */
    param_str   strv;   /* STR */
    param_pix   pixv;   /* PIXEL */
    param_font  fontv;  /* FONT */
    param_style stylev; /* STYLE */
    param_bool  boolv;  /* BOOL */
    param_dbl   dblv;   /* DBL */
} params;

/*  from ( params.c )  */
/*  -----------------  */

typedef struct param_full_defn {
    param_types type;
    char       *text_form;
    params     *real_form;
} param_full;

/*  from ( ps.c )  */
/*  -------------  */

typedef struct userInfo_defn {
    FILE   *psFile;
    int     currentTextStyle;
    int     currentDashStyle;
    int     currentWidth;
    int     currentLStyle;
    int     currentColor;
    int     baseWidth;
    int     height_devs;
    char   *title_family;
    double  title_size;
    char   *axis_family;
    double  axis_size;
    int     flags;
} userInfo;

/*  from ( read.c )  */
/*  ---------------  */

typedef enum line_type {
    EMPTY,
    COMMENT,
    SETNAME,
    DRAWPNT,
    MOVEPNT,
    SETPARAM,
    ERROR
} LineType;

typedef struct point_defn {
    double  xval;
    double  yval;
} Point;

typedef struct parmval_defn {
    char  *name;
    char  *value;
} ParmVals;

typedef struct line_info {
    LineType        type;
    union val_defn {
	            char    *str;  /* SETNAME, ERROR   */
	            Point    pnt;  /* DRAWPNT, MOVEPNT */
	            ParmVals parm; /* SETPARAM         */
                   } val;
} LineInfo;

/*  from ( st.h )  */
/*  -------------  */

typedef struct st_table_entry {
    char                  *key;
    char                  *record;
    struct st_table_entry *next;
} st_table_entry;

typedef struct st_table {
    int              (*compare) ();
    int              (*hash) ();
    int              num_bins;
    int              num_entries;
    int              max_density;
    int              reorder_flag;
    double           grow_factor;
    st_table_entry **bins;
} st_table;

typedef struct st_generator {
    st_table       *table;
    st_table_entry *entry;
    int             idx;
} st_generator;

/*  from ( xgout.h )  */
/*  ----------------  */

typedef struct xg_out_defn {
    int     dev_flags;     /* Device characteristic flags           */
    int     area_w;        /* Width  in screen pixels               */
    int     area_h;        /* Height in screen pixels               */
    int     bdr_pad;       /* Padding from border                   */
    int     axis_pad;      /* Extra space around axis labels        */
    int     tick_len;      /* Length of tick mark on axis           */
    int     legend_pad;    /* Top of legend text to legend line     */
    int     axis_width;    /* Width  of big character of axis font  */
    int     axis_height;   /* Height of big character of axis font  */
    int     title_width;   /* Width  of big character of title font */
    int     title_height;  /* Height of big character of title font */
    int     max_segs;      /* Maximum number of segments in group   */

    double  margin_l;      /* Left    margin in inches              */
    double  margin_r;      /* Right   margin in inches              */
    double  margin_t;      /* Top     margin in inches              */
    double  margin_b;      /* Bottom  margin in inches              */

    void    (*xg_text) (); /* Draws text at a location              */
    void    (*xg_seg) ();  /* Draws a series of segments            */
    void    (*xg_dot) ();  /* Draws a dot or marker at a location   */
    void    (*xg_end) ();  /* Stops the drawing sequence            */

    char   *user_state;	   /* User supplied data                    */
} xg_out;

/*  from ( xgraph.h )  */
/*  -----------------  */

typedef unsigned long  Pixel;

typedef struct point_list {
    int                numPoints; /* Number of points in group */
    int                allocSize; /* Allocated size            */
    double            *xvec;      /* X values                  */
    double            *yvec;      /* Y values                  */
    struct point_list *next;      /* Next set of points        */
} PointList;

typedef struct new_data_set {
    char      *setName; /* Name of data set     */
    PointList *list;    /* List of point arrays */
} NewDataSet;

typedef struct local_win {
    double  loX,     loY,
            hiX,     hiY;     /* Local bounding box of window         */
    int     XOrgX,   XOrgY;   /* Origin of bounding box on screen     */
    int     XOppX,   XOppY;   /* Other point defining bounding box    */
    int     Xmarg_l, Xmarg_r; /* Margins (left,right) (% of width)    */
    int     Xmarg_t, Xmarg_b; /* Margins (top,bottom) (% of height)   */
    double  UsrOrgX, UsrOrgY; /* Origin of bounding box in user space */
    double  UsrOppX, UsrOppY; /* Other point of bounding box          */
    double  XUnitsPerPixel;   /* X Axis scale factor                  */
    double  YUnitsPerPixel;   /* Y Axis scale factor                  */
    double  Xbegin,  Ybegin;  /* Begining locations for SCREEN*()     */
    xg_out  dev_info;         /* Device information                   */
    Window  close;            /* Button for closing                   */
    Window  hardcopy;         /* Button for hardcopy                  */
    Window  about;            /* Version information                  */
    Window  rewind;           /* PW Added this, for animation.        */
    Window  replot;           /* PW Added this, for animation.        */
    Window  deriv;            /* PW Added this, for animation.        */
    int     flags;            /* Window flags                         */
    int     DOrder;           /* Which order of Derivative is set?    */
} LocalWin;

/*  from ( xgX.c )  */
/*  --------------  */

typedef struct attr_set {
    char    lineStyle[MAXLS];
    int     lineStyleLen;
    Pixel   pixelValue;
    Pixmap  markStyle;
} AttrSet;

typedef struct x_state_defn {
    Window  win;  /* Primary window */
} x_state;

/*  from ( xtb.h )  */
/*  ---------------  */

typedef enum xtb_fmt_types_defn {
    W_TYPE,
    A_TYPE
} xtb_fmt_types;

typedef enum xtb_fmt_dir_defn {
    HORIZONTAL,
    VERTICAL
} xtb_fmt_dir;

typedef enum xtb_just_defn {
    XTB_CENTER = 0,
    XTB_LEFT,
    XTB_RIGHT,
    XTB_TOP,
    XTB_BOTTOM
} xtb_just;

typedef struct xtb_frame_defn { /* Basic return value */
    Window       win;
    int          x_loc;
    int          y_loc;
    unsigned int width;
    unsigned int height;
} xtb_frame;

typedef struct xtb_fmt_widget_defn {
    xtb_fmt_types type;		/* W_TYPE */
    xtb_frame    *w;
} xtb_fmt_widget;

typedef struct xtb_fmt_align_defn {
    xtb_fmt_types       type;	           /* A_TYPE */
    xtb_fmt_dir         dir;	           /* HORIZONTAL or VERTICAL */
    int                 padding;	   /* Outside padding        */
    int                 interspace;	   /* Internal padding       */
    xtb_just            just;	           /* Justification          */
    int                 ni;                /* Number of items */
    union xtb_fmt_defn *items[MAX_BRANCH]; /* Branches themselves */
} xtb_fmt_align;

typedef union xtb_fmt_defn {
    xtb_fmt_types  type;  /* W_TYPE or A_TYPE   */
    xtb_fmt_widget wid;   /* Window definitions */
    xtb_fmt_align  align; /* Alignment data     */
} xtb_fmt;

/*  from ( xtb.c )  */
/*  --------------  */

typedef struct h_info_defn {
    xtb_hret (*func) (XEvent   *evt,
                      xtb_data  info);	/* Function to call */
    xtb_data   info;		        /* Additional info  */
} h_info;

typedef struct br_info_defn {
    Window     main_win;	     /* Main button row    */
    int        which_one;	     /* Which button is on */
    int        btn_cnt;		     /* How many buttons   */
    xtb_hret (*func) (Window   win,
                      int      prev,
                      int      this,
                      xtb_data val);
    xtb_data   val;		     /* User data          */
    Window    *btns;		     /* Button windows     */
} br_info;
