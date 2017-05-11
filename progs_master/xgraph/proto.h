
/*************************/
/*                       */
/*  P R O T O T Y P E S  */
/*                       */
/*************************/

void Bounds( double *loX , 
             double *loY , 
             double *hiX , 
             double *hiY , 
             int    Ord  );

void *Calloc( unsigned n  , 
              unsigned sz );

void DelWindow( Window   win       ,  /* Window     */
                LocalWin *win_info ); /* Local Info */

void Der1( void );

void DrawData( LocalWin *wi );

void DrawGridAndAxis( LocalWin *wi ); /* Window information         */

void DrawLegend( LocalWin *wi );

void DrawTitle( LocalWin *wi ); /* Window information    */

void DrawWindow( LocalWin *win_info ); /* Window information */

void EraseData( LocalWin *wi );

void Free( void *ptr );

int HandleZoom( char                *progname , 
                XButtonPressedEvent *evt      , 
                LocalWin            *wi       , 
                Cursor              cur       );

void InitSets( int o );

void *Malloc( unsigned n );

void MaxLabelSize( LocalWin *wi      ,  /* Window information          */
                   int      *label_x ,  /* max x-label in # characters */
                   int      *label_y ,  /* max y-label in # characters */
                   int      *expon_x ,  /* exponent for x-label values */
                   int      *expon_y ); /* exponent for y-label values */

void MemChain( void );

unsigned MemPtr( void *ptr );

unsigned MemStat( void );

Window NewWindow( char   *progname ,  /* Name of program    */
                  double lowX      ,  /* Lower left corner  */
                  double lowY      ,  /* Lower left corner  */
                  double upX       ,  /* Upper right corner */
                  double upY       ,  /* Upper right corner */
                  double asp       ,  /* Aspect ratio       */
                  int    DO        ); /* Derivative Order.  */

int ParseArgs( int  argc    , 
               char *argv[] , 
               int  do_it   );

void PrintWindow( Window   win       ,  /* Window       */
                  LocalWin *win_info ); /* Local Info   */

int ReadData( FILE *stream   , 
              char *filename );

void ReadDefaults( void );

void *Realloc( void     *ptr , 
               unsigned n    );

void ReverseIt( void );

void ReversePix( char *param_name ); /* Name of color parameter */

double RoundUp( double val ); /* Value */

int  ScreenX( LocalWin *wi    ,
              double    userX );

int  ScreenY( LocalWin *wi    ,
              double    userY );

int TransformCompute( LocalWin *wi ); /* Window information          */

void Traverse( int flags ); /* Options */

int  Window_Geometry(xtb_frame *frame );

void WriteValue( char   *str    ,  /* String to write into */
                 char   *fmt    ,  /* Format to print str */
                 double val     ,  /* Value to print       */
                 int    expv    ,  /* Exponent             */
                 int    logFlag ); /* Is this a log axis?  */

int XErrHandler( Display     *disp_ptr , 
                 XErrorEvent *evt      );

xtb_hret abt_func( Window win   ,  /* Button window    */
                   int    bval  ,  /* Button value     */
                   void   *info ); /* User information */

void argerror( char *err , 
               char *val );

void axisSizing( LocalWin *wi      ,  /* Window information  */
                 int       axis_id ,  /* 0 = X, 1 = Y        */
                 double    Delta   ,  /* Tic mark distance   */
                 double   *Start   ,  /* Begining value      */
                 double   *Final   ,  /* Ending   value      */
                 int      *num     ); /* Number of tic marks */

xtb_hret br_h( Window   win  , 
               int      val  , 
               xtb_data info );

void bt_draw( Window win , 
              b_info *ri );

xtb_hret bt_h( XEvent   *evt , 
               xtb_data info );

void bt_line( Window        win , 
              b_info        *ri , 
              unsigned long pix );

xtb_hret can_fun( Window   win  ,  /* Button window     */
                  int      val  ,  /* Button value      */
                  xtb_data info ); /* Local button info */

xtb_hret del_func( Window win   ,  /* Button window    */
                   int    bval  ,  /* Button value     */
                   void   *info ); /* User information */

void  del_msg_box( Window msg );

xtb_hret  der_func( Window win   ,  /* Button window    */
                    int    bval  ,  /* Button value     */
                    char   *info ); /* User information */

xtb_hret  dev_fun( Window   win  ,  /* Button row window */
                   int      old  ,  /* Previous button   */
                   int      new  ,  /* Current button    */
                   xtb_data info ); /* User data         */

xtb_hret  df_fun( Window   win   ,  /* Widget window   */
                  int      ch    ,  /* Typed character */
                  char     *text ,  /* Copy of text    */
                  xtb_data val   ); /* User info       */

int do_bool( char *name ,  /* String representation */
             int  *val  ); /* Returned value        */

int do_color( char   *name  ,  /* Name for color */
              XColor *color ); /* Returned color */

void  do_error( char *err_text );

int do_font( char        *name       ,  /* Name of desired font      */
             XFontStruct **font_info ); /* Returned font information */

void do_hardcopy( int      device_no     ,  /* Hardcopy device ID number     */
                  char    *prog          ,  /* Program name for Xdefaults    */
                  char    *info          ,  /* Some state information        */
                  int    (*init_fun) ()  ,  /* Hardcopy init function        */
                  char    *dev_spec      ,  /* Device specification (if any) */
                  char    *file_or_dev   ,  /* Filename or device spec       */
                  double   max_width     ,  /* Maximum width  in cm          */
                  double   max_height    ,  /* Maximum height in cm          */
                  char    *ti_fam        ,  /* Font family names             */
                  double   ti_size       ,  /* Font sizes in points          */
                  char    *ax_fam        ,  /* Font family names             */
                  double   ax_size       ,  /* Font sizes in points          */
                  int      doc_p         ,  /* Documentation predicate       */
                  int      fit_or_asp    ); /* Fit-to-Page or Keep-Aspect    */

int do_style( char        *list ,  /* List of ones and zeros */
              param_style *val  ); /* Line style returned    */

xtb_hret  docu_fun( Window   win  ,  /* Button window     */
                    int      val  ,  /* Button value      */
                    xtb_data info ); /* Local button info */

GC  dotGC( Window d_win      ,  /* Window for making GC */
           Pixel  d_fg       ,  /* Foreground color */
           Pixmap d_clipmask ,  /* Clipmask         */
           int    d_xorg     ,  /* Clipmask origin  */
           int    d_yorg     ); /* Clipmask origin  */

void  dot_X( char *user_state ,  /* Value set in xg_init    */
             int  x           ,  /* Location in pixel units */
             int  y           ,  /* Location in pixel units */
             int  style       ,  /* Dot style               */
             int  type        ,  /* Type of marker          */
             int  color       ); /* Marker color (if any)   */

enum st_retval dump_it( char *key   , 
                        char *value , 
                        char *arg   );

void  errRaise( char *pkg , 
                int  num  , 
                char *msg );

xtb_hret  err_func( Window   win  ,  /* Button window     */
                    int      bval ,  /* Button value      */
                    xtb_data info ); /* Local button info */

xtb_hret  fd_fun( Window   win  ,  /* Button row window */
                  int      old  ,  /* Previous button   */
                  int      new  ,  /* Current button    */
                  xtb_data info ); /* User data         */

void focus_evt( XEvent *evt );

void free_resource( params *val ); /* Value to free */

void get_color( char   *name  ,  /* Name for color */
                XColor *color ); /* Returned color */

int  get_line( char **tptr , 
               char *lptr  );

void  get_margins( LocalWin *wi );

Pixmap gray_map( Window win );

void  hard_init( void );

xtb_hret hcpy_func( Window win   ,  /* Button Window    */
                    int    bval  ,  /* Button value     */
                    void   *info ); /* User Information */

void  ho_dialog( Window   parent ,  /* Parent window              */
                 char     *prog  ,  /* Program name               */
                 xtb_data cookie ); /* Info passed to do_hardcopy */

void hpglDot( mydata *userState ,  /* my state information (not used) */
              int    x          ,  /* coords of text origin */
              int    y          ,  /* coords of text origin */
              int    style      ,  /* type of dot */
              int    type       ,  /* dot style variation */
              int    color      ); /* color of dot */

void hpglEnd( mydata *userState ); /* my state information (not used) */

int hpglInit( FILE   *stream            ,  /* output stream */
              int    width              ,  /* desired width of space in microns */
              int    height             ,  /* desired height in microns */
              char   *title_family      ,  /* name of font for titles */
              double title_size         ,  /* size of font for titles */
              char   *axis_family       ,  /* name of font for axes */
              double axis_size          ,  /* size of font for axes */
              int    flags              ,  /* predicate values (ignored) */
              xg_out *outInfo           ,  /* my structure */
              char   errmsg[ERRBUFSIZE] ); /* a place to complain to */

void hpglSeg( mydata   *userState ,  /* my state information (not used) */
              int      ns         ,  /* number of segments */
              XSegment *segs      ,  /* X array of segments */
              int      width      ,  /* width of lines in pixels */
              int      style      ,  /* L_VAR = dotted, L_AXIS = grid, L_ZERO = axis */
              int      lappr      ,  /* line style */
              int      color      ); /* line color */

void hpglText( mydata *userState ,  /* my state information  */
               int    x          ,  /* coords of text origin */
               int    y          ,  /* coords of text origin */
               char   *text      ,  /* what to put there */
               int    just       ,  /* how to justify */
               int    style      ); /* T_AXIS = axis font, T_TITLE = title font */

void  iCalComp( LocalWin *wi );

void  idrawDot( char *user_state ,  /* Value set in xg_init    */
                int  x           ,  /* Location in pixel units */
                int  y           ,  /* Location in pixel units */
                int  style       ,  /* Dot style               */
                int  type        ,  /* Type of marker          */
                int  color       ); /* Marker color (if any)   */

void  idrawEnd( char *user_state );

int  idrawInit( FILE   *strm              ,  /* Output stream              */
                int    width              ,  /* Size of space (microns)    */
                int    height             ,  /* Size of space (microns)    */
                char   *title_family      ,  /* Name of title font family  */
                double title_size         ,  /* Title font height (points) */
                char   *axis_family       ,  /* Name of axis font family   */
                double axis_size          ,  /* Axis font height (points)  */
                int    flags              ,  /* Flags                      */
                xg_out *out_info          ,  /* Device info (RETURN)       */
                char   errmsg[ERRBUFSIZE] ); /* Error message area         */

void  idrawSeg( char     *user_state ,  /* Value set in xg_init */
                int      ns          ,  /* Number of segments   */
                XSegment *seglist    ,  /* X array of segments  */
                int      width       ,  /* Width of lines       */
                int      style       ,  /* See above            */
                int      lappr       ,  /* Line appearence      */
                int      color       ); /* Line color (if any)  */

void  idrawText( char *user_state ,  /* Value set in xg_init   */
                 int  x           ,  /* Text position (pixels) */
                 int  y           ,  /* Text position (pixels) */
                 char *text       ,  /* Null terminated text   */
                 int  just        ,  /* Justification (above)  */
                 int  style       ); /* Text style (above)     */

void  idraw_just( int *x   ,  /* Given location (lower left) */
                  int *y   ,  /* Given location (lower left) */
                  int just ,  /* Justification */
                  int size ,  /* Size in points */
                  int len  ); /* Number of chars */

void  ini_marg_pc( LocalWin *wi ); 

double initGrid( double low     ,  /* desired low value          */
                 double step    ,  /* desired step (user coords) */
                 int    logFlag ); /* is axis logarithmic?       */

void  init_X( char *user_state );

void  init_once( void );

int main( int  argc    , 
          char *argv[] );

void  make_dialog( Window    win     ,  /* Parent window          */
                   Window    spawned ,  /* Spawned from window    */
                   char      *prog   ,  /* Program name           */
                   xtb_data  cookie  ,  /* Info for do_hardcopy  */
                   xtb_frame *okbtn  ,  /* Frame for OK button    */
                   xtb_frame *frame  ); /* Returned window/size   */

void  make_msg_box( char      *text  ,  /* Error text    */
                    char      *title ,  /* Title text    */
                    xtb_frame *frame ); /* Returned frame */

int  make_otpnam( int   ifn    ,  /* index of input  file name  */
                  int   ityp   ,  /* index of output file type  */
                  int   lfn    ,  /* maximum length of filnam[] */
                  char *filnam ); /* desired output file name   */

Window  make_shadow( int    width  ,  /* window width  */
                     int    height ); /* shadow color  */

Pixmap make_stipple( Display      *disp  , 
                     Drawable     able   , 
                     char         *bits  , 
                     unsigned int width  , 
                     unsigned int height );

void  msg_box( char *title , 
               char *text  );

xtb_hret  ok_fun( Window   win  ,  /* Button window     */
                  int      bval ,  /* Button value      */
                  xtb_data info ); /* Local button info */

xtb_hret  ofmt_fun( Window   win  ,  /* Button row window */
                    int      old  ,  /* Previous button   */
                    int      new  ,  /* Current button    */
                    xtb_data info ); /* User data         */

void param_dump( void );

params *param_get( char   *name ,  /* Name of parameter */
                   params *val  ); /* Result value      */

void param_init( Display  *disp ,  /* X Connection        */
                 Colormap cmap  ); /* Colormap for colors */

void param_reset( char *name ,  /* Name of parameter   */
                  char *val  ); /* Text form for value */

void param_set( char        *name ,  /* Name of parameter   */
                param_types type  ,  /* Type                */
                char        *val  ); /* Text form for value */

LineType parse_line( char     *line   ,  /* Line to parse   */
                     LineInfo *result ); /* Returned result */

void  psDot( char *state ,  /* state information */
             int  x      ,  /* coord of dot */
             int  y      ,  /* coord of dot */
             int  style  ,  /* type of dot */
             int  type   ,  /* dot style variation */
             int  color  ); /* color of dot */

void  psEnd( char *userState ); /* state information */

void  psFonts( FILE *psFile ); /* Output stream */

void  psHeader( FILE *psFile   , 
                int  docu_flag );

int  psInit( FILE   *psFile             ,  /* Output file            */
             int     width              ,  /* In microns             */
             int     height             ,  /* In microns             */
             char   *tf                 ,  /* Title font name        */
             double  ts                 ,  /* Title font size        */
             char   *af                 ,  /* Axis  font name        */
             double  as                 ,  /* Axis  font size        */
             int     flags              ,  /* Predicate flags        */
             xg_out *outInfo            ,  /* Returned device info   */
             char    errmsg[ERRBUFSIZE] ); /* Returned error message */

void  psMarks( FILE *psFile );

void  psScale( FILE    *psFile ,  /* Output stream      */
               int     width   ,  /* Output width       */
               int     height  ,  /* Output height      */
               xg_out *outInfo ); /* Output device info */

void  psSeg( char     *state   ,  /* Really (struct userInfo *) */
             int      ns       ,  /* Number of segments         */
             XSegment *seglist ,  /* X array of segments        */
             int      width    ,  /* Width of lines (devcoords) */
             int      style    ,  /* L_AXIS, L_ZERO, L_VAR      */
             int      lappr    ,  /* Zero to seven              */
             int      color    ); /* Zero to seven              */

void  psText( char *state ,  /* Really (struct userInfo *) */
              int  x      ,  /* Text position (devs)       */
              int  y      ,  /* Text position (devs)       */
              char *text  ,  /* Text itself                */
              int  just   ,  /* Justification              */
              int  style  ); /* Style                      */

int  rd( double dbl );

int rdFindMax( void );

void rdGroup( void );

void rdPoint( double xval , 
              double yval );

int rdSet( char *fn ); /* Reading from file `fn' */

void rdSetName( char *name ); /* New set name */

void  rehash( st_table *table );

params *resolve_entry( char        *name ,  /* Name of item for errors */
                       param_types type  ,  /* What type of thing */
                       char        *form ); /* Textual form       */

xtb_hret  rew_func( Window win   ,  /* Button window    */
                    int    bval  ,  /* Button value     */
                    char   *info ); /* User information */

xtb_hret  rpl_func( Window win   ,  /* Button window    */
                    int    bval  ,  /* Button value     */
                    char   *info ); /* User information */

GC  segGC( Window l_win    ,  /* Window for making GC */
           Pixel  l_fg     ,  /* Foreground color */
           int    l_style  ,  /* Line style       */
           int    l_width  ,  /* Line width       */
           char   *l_chars ,  /* Character spec   */
           int    l_len    ); /* Length of spec   */

void  seg_X( char     *user_state ,  /* Value set in xg_init */
             int      ns          ,  /* Number of segments   */
             XSegment *segs       ,  /* X array of segments  */
             int      width       ,  /* Width of lines       */
             int      style       ,  /* See above            */
             int      lappr       ,  /* Line appearence      */
             int      color       ); /* Line color (if any)  */

void  set_Grid( double  zmin ,
                double  zmax ,
                double  axis ,
                double *zbeg ,
                double *zend ,
                double *zdel );

void  set_X( Window new_win   ,  /* Newly created window */
             xg_out *out_info ); /* Information to set   */

GC set_gc( Window        win    ,  /* For creating GC  */
           unsigned long fg     ,  /* Foreground pixel */
           unsigned long bg     ,  /* Background pixel */
           Font          font   ,  /* Font             */
           int           gray_p ); /* Gray if set      */

void set_mark_flags( int *markFlag   , 
                     int *pixelMarks , 
                     int *bigPixel   , 
                     int *colorMark  );


/* new routines added to eliminate DEFINE's */

int  do_hash( char     *key   ,
              st_table *table );

int  is_equal( int    func() ,
               char  *x      ,
               char  *y      );
 
int  ptr_not_equal( st_table        *table ,
                    st_table_entry  *ptr   ,
                    char            *key   );

void  find_entry( st_table        *table ,
                  int              hash  ,
                  char            *key   ,
                  st_table_entry **ptro  ,
                  st_table_entry **last  );

void  add_direct( st_table        *table ,
                  char            *key   ,
                  char            *value ,
                  int              hashi ,
                  st_table_entry **new   );


/* end of newly added routines */

void st_Free_gen( st_generator *gen );

void st_Free_table( st_table *table );

void  st_add_direct( st_table *table , 
                     char     *key   , 
                     char     *value );

st_table *st_copy( st_table *old_table );

int  st_delete( st_table  *table , 
                char     **keyp  , 
                char     **value );

int  st_find( st_table *table  , 
              char     *key    , 
              char     ***slot );

int  st_find_or_add( st_table *table  , 
                     char     *key    , 
                     char     ***slot );

int  st_foreach( st_table               *table , 
                 enum st_retval (*func) ()     , 
                 char                   *arg   );

int st_gen( st_generator *gen      , 
            char         **key_p   , 
            char         **value_p );

st_generator *st_init_gen( st_table *table );

st_table *st_init_table( int (*compare) () , 
                         int (*hash)    () );

st_table *st_init_table_with_params( int    (*compare) () , 
                                     int    (*hash)    () , 
                                     int    size          , 
                                     int    density       , 
                                     double grow_factor   , 
                                     int    reorder_flag  );

int  st_insert( st_table *table , 
                char     *key   , 
                char     *value );

int  st_lookup( st_table  *table , 
                char      *key   , 
                char     **value );

int  st_numcmp( char *x , 
                char *y );

int  st_numhash( char *x   , 
                 int  size );

int  st_ptrcmp( char *x , 
                char *y );

int  st_ptrhash( char *x   , 
                 int  size );

int  st_strhash( char *string  , 
                 int   modulus );

double stepGrid( void );

int stricmp( char *a , 
             char *b );

int strihash( char *string  , 
              int   modulus );

GC  textGC( Window      t_win   ,  /* Window for making GC */
            XFontStruct *t_font ); /* Text font            */

void  text_X( char *user_state ,  /* Value set in xg_init   */
              int  x           ,  /* Text position (pixels) */
              int  y           ,  /* Text position (pixels) */
              char *text       ,  /* Null terminated text   */
              int  just        ,  /* Justification (above)  */
              int  style       ); /* Text style (above)     */

int text_width( XFontStruct *font ,  /* What font       */
                char        *str  ,  /* Character array */
                int         len   ); /* Length of array */

void  tgifDot( char *user_state ,  /* Value set in xg_init    */
               int  x           ,  /* Location in pixel units */
               int  y           ,  /* Location in pixel units */
               int  style       ,  /* Dot style               */
               int  type        ,  /* Type of marker          */
               int  color       ); /* Marker color (if any)   */

void  tgifEnd( char *user_state );

int  tgifInit( FILE   *strm              ,  /* Output stream              */
               int    width              ,  /* Size of space (microns)    */
               int    height             ,  /* Size of space (microns)    */
               char   *title_family      ,  /* Name of title font family  */
               double title_size         ,  /* Title font height (points) */
               char   *axis_family       ,  /* Name of axis font family   */
               double axis_size          ,  /* Axis font height (points)  */
               int    flags              ,  /* Flags                      */
               xg_out *out_info          ,  /* Device info (RETURN)       */
               char   errmsg[ERRBUFSIZE] ); /* Error message area         */

void  tgifSeg( char     *user_state ,  /* Value set in xg_init */
               int      ns          ,  /* Number of segments   */
               XSegment *seglist    ,  /* X array of segments  */
               int      width       ,  /* Width of lines       */
               int      style       ,  /* See above            */
               int      lappr       ,  /* Line appearence      */
               int      color       ); /* Line color (if any)  */

void  tgifText( char *user_state ,  /* Value set in xg_init   */
                int  x           ,  /* Text position (pixels) */
                int  y           ,  /* Text position (pixels) */
                char *text       ,  /* Null terminated text   */
                int  just        ,  /* Justification (above)  */
                int  style       ); /* Text style (above)     */

void  tgif_just( int *x   ,  /* Given location (lower left) */
                 int *y   ,  /* Given location (lower left) */
                 int just ,  /* Justification */
                 int size ,  /* Size in points */
                 int len  ); /* Number of chars */

void ti_cursor_off( Window  win , 
                    ti_info *ri );

void ti_cursor_on( Window  win , 
                   ti_info *ri );

void ti_draw( Window  win    , 
              ti_info *ri    , 
              int     c_flag );

xtb_hret ti_h( XEvent   *evt , 
               xtb_data info );

void ti_line( Window         win , 
              ti_info        *ri , 
              unsigned long  pix );

char *tildeExpand( char *out ,  /* Output space for expanded file name */
                   char *in  ); /* Filename with tilde                 */

void to_draw( Window  win , 
              to_info *ri );

xtb_hret to_h( XEvent   *evt , 
               xtb_data info );



void xtb_bk_del( Window win );

void xtb_bk_new( Window    win    ,  /* Parent window */
                 unsigned  width  ,  /* Size          */
                 unsigned  height ,  /* Size          */
                 xtb_frame *frame ); /* Returned size */

void xtb_br_del( Window win );

int  xtb_br_get( Window win );

void xtb_br_new( Window    win      ,              /* Parent window    */
                 int       cnt      ,              /* Count of buttons */
                 char      *lbls[]  ,              /* Button labels    */
                 int       init     ,              /* Initial button   */
                 xtb_hret  (*func) (Window   win,
                                    int      prev,
				    int      this,
                                    xtb_data val), /* Callback func    */
                 xtb_data  val      ,              /* User data        */
                 xtb_frame *frame   );             /* Returned size    */

void xtb_bt_del( Window   win   , 
                 xtb_data *info );

int  xtb_bt_get( Window   win    , 
                 xtb_data *stuff , 
                 int      *na    );

void xtb_bt_new( Window    win      ,                 /* Parent window     */
                 char      *text    ,                 /* Text in button    */
                 xtb_hret  (*func) (Window   win,
                                    int      state,
                                    xtb_data val  ) , /* Callback func     */
                 xtb_data  val      ,                 /* User data         */
                 xtb_frame *frame   );                /* Size (RETURN)     */

int  xtb_bt_set( Window   win   , 
                 int      val   , 
                 xtb_data stuff , 
                 int      na    );

xtb_hret xtb_dispatch( XEvent *evt );

void xtb_fmt_addpos( xtb_fmt *def , 
                     int     x    , 
                     int     y    );

void xtb_fmt_debug( xtb_fmt *def );

xtb_fmt *xtb_fmt_do( xtb_fmt  *def , 
                     unsigned *w   , 
                     unsigned *h   );

void xtb_fmt_free( xtb_fmt *def );

void xtb_fmt_hort( int           ndefs     ,  /* Number of children     */
                   xtb_fmt      *defs[]    ,  /* Definitions themselves */
                   unsigned int  widths[]  ,  /* Widths of children     */
                   unsigned int  heights[] ,  /* Heights of children    */
                   xtb_just      just      ,  /* Justification          */
                   int           pad       ,  /* Padding                */
                   int           inter     ,  /* Interspacing           */
                   unsigned int *rw        ,  /* returned total width   */
                   unsigned int *rh        ); /* returned total height  */

void xtb_fmt_setpos( xtb_fmt *def , 
                     int     x    , 
                     int     y    );

void xtb_fmt_top( xtb_fmt  *def , 
                  unsigned *w   , 
                  unsigned *h   );

void xtb_fmt_vert( int           ndefs     ,  /* Number of children     */
                   xtb_fmt      *defs[]    ,  /* Definitions themselves */
                   unsigned int  widths[]  ,  /* Widths of children     */
                   unsigned int  heights[] ,  /* Heights of children    */
                   xtb_just      just      ,  /* Justification          */
                   int           pad       ,  /* Padding                */
                   int           inter     ,  /* Interspacing           */
                   unsigned int *rw        ,  /* returned total width   */
                   unsigned int *rh        ); /* returned total height  */

xtb_fmt *xtb_hort (xtb_just just       ,  /* Justification  */
                   int      padding    ,
                   int      interspace ,
                   ...);

void xtb_init( Display       *disp      ,  /* Display          */
               int           scrn       ,  /* Screen number    */
               unsigned long foreground ,  /* Foreground color */
               unsigned long background ,  /* Background color */
               unsigned long border     ,  /* Border     color */
               XFontStruct   *font      ); /* Normal font      */

xtb_data xtb_lookup( Window win );

void xtb_mv_frames( int       nf       ,  /* Number of frames */
                    xtb_frame frames[] ); /* Array of frames  */

void xtb_register( Window    win      , 
                   xtb_hret  (*func) (XEvent  *evt,
                                      xtb_data info) ,
                   xtb_data  info     );

int xtb_ti_dch( Window win ); /* Widget window */

void xtb_ti_del( Window   win   , 
                 xtb_data *info );

void xtb_ti_get( Window   win            ,  /* Widget widnow  */
                 char     text[MAXCHBUF] ,  /* Filled in text */
                 xtb_data *val           ); /* User info      */

int xtb_ti_ins( Window win ,  /* Widget window */
                int    ch  ); /* Character     */

void xtb_ti_new( Window    win      ,                 /* Parent window      */
                 char      *text    ,                 /* Initial text       */
                 int       maxchar  ,                 /* Maximum characters */
                 xtb_hret  (*func) (Window    win,
                                    int       ch,
                                    char     *textcopy,
                                    xtb_data  val) ,  /* Callback func      */
                 xtb_data  val      ,                 /* User data          */
                 xtb_frame *frame   );                /* Returned size      */

int xtb_ti_set( Window   win   ,  /* Widget window    */
                char     *text ,  /* Replacement text */
                xtb_data val   ); /* User info        */

void xtb_to_del( Window win );

void xtb_to_new( Window      win    ,  /* Parent window */
                 char        *text  ,  /* Text          */
                 XFontStruct *ft    ,  /* Font to use   */
                 xtb_frame   *frame ); /* Returned size */

int xtb_unregister( Window   win   , 
                    xtb_data *info );

xtb_fmt *xtb_vert (xtb_just just       ,  /* Justification  */
                   int      padding    ,
                   int      interspace ,
                   ...);

xtb_fmt *xtb_w( xtb_frame *w );
