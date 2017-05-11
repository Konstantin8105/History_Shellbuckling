
#include "aparms.h"

/*
 * Hardcopy Devices
 *
 * This file contains the basic output device table.  The hardcopy
 * dialog is automatically constructed from this table.
 *
 * $Log: hard_devices.c,v $
 * Revision 1.1.1.1  1999/12/03 23:15:52  heideman
 * xgraph-12.0
 *
 */

//struct hard_dev {
//    char   *dev_name;		      /* Device name                       */
//    int   (*dev_init) ();	      /* Initialization function           */
//    char   *dev_spec;		      /* Default pipe program              */
//    char    dev_file[MFNAME];	      /* Default file name                 */
//    char    dev_printer[MFNAME];    /* Default printer name              */
//    double  dev_max_width;	      /* Default maximum width  (cm)       */
//    double  dev_max_height;	      /* Default maximum height (cm)       */
//    char    dev_title_font[MFNAME]; /* Default name of title font        */
//    double  dev_title_size;	      /* Default size of title font (pnts) */
//    char    dev_axis_font[MFNAME];  /* Default name of axis font         */
//    double  dev_axis_size;	      /* Default size of axis font (pnts)  */
//    hard_dev_docu dev_docu;	      /* Document predicate                */
//};

hard_dev hard_devices[] =
{
  {"HPGL",       hpglInit, "lpr -P%s", "xgraph.hpgl", "paper",    27.50, 27.50, "1",          14.0, "1",           12.0, NONE},
  {"Idraw",      idrawInit,"cat > /usr/tmp/idraw.tmp.ps; %s /usr/tmp/idraw.tmp.ps&", "~/.clipboard", "/usr/bin/X11/idraw", 
                                                                  25.00, 25.00, "Times-Bold", 18.0, "Times-Roman", 12.0, NONE},
  {"Postscript", psInit,   "lpr -P%s", "xgraph.ps",   "$PRINTER", 21.59, 27.94, "Times-Bold", 18.0, "Times-Roman", 12.0, NO},
  {"Tgif",       tgifInit, "cat > /usr/tmp/xgraph.obj; %s /usr/tmp/xgraph &", "xgraph.obj", "/usr/bin/X11/tgif",
                                                                  25.00, 25.00, "Times-Bold", 18.0, "Times-Roman", 12.0, NONE}
};

int     hard_count = sizeof(hard_devices) / sizeof(hard_dev);

char   *hd_name_extn[] = { ".hpgl"  ,
                           ".idraw" ,
                           ".ps"    ,
                           ".tgif"  };

#define CHANGE_D(name, field) \
if (param_get(name, &val)) { \
    if (val.type == DBL) { \
       hard_devices[idx].field = val.dblv.value; \
    } \
}

#define CHANGE_F(name, field) \
if (param_get(name, &val)) { \
    if (val.type == DBL) { \
       field = val.dblv.value; \
    } \
    else { \
       field = 0.0; \
    } \
} \
else { \
   field = 0.0; \
}

#define CHANGE_S(name, field) \
if (param_get(name, &val)) { \
    if (val.type == STR) { \
       (void) strcpy(hard_devices[idx].field, val.strv.value); \
    } \
}


/***************/
/*  hard_init  */
/***************/

void  hard_init( void ) 
/*
 * changes values in hard_device structures in accordance with
 * parameters set using the parameters module.
 */
{
    char    nn[BUFSIZ];
    char    filnam[MFNAME];
    int     lfn = MFNAME - 1;
    int     ifn;
    int     idx;
    params  val;
    double  max_cm,
            max_dev,
            max_w,
            max_h;

    for (idx = 0; idx < hard_count; idx++) {

        (void) sprintf(nn, "%s.Dimension",       hard_devices[idx].dev_name);
        CHANGE_F(nn, max_cm);

        if (max_cm > 0.0) {
            max_w   = hard_devices[idx].dev_max_width;
            max_h   = hard_devices[idx].dev_max_height;
            max_h   = max_h  >   0.0 ? max_h : max_w;
            max_dev = max_w  > max_h ? max_w : max_h;

	    hard_devices[idx].dev_max_width  = max_w * max_cm / max_dev;
	    hard_devices[idx].dev_max_height = max_h * max_cm / max_dev;
        }

        (void) sprintf(nn, "%s.OutputTitleFont", hard_devices[idx].dev_name);
        CHANGE_S(nn, dev_title_font);

        (void) sprintf(nn, "%s.OutputTitleSize", hard_devices[idx].dev_name);
        CHANGE_D(nn, dev_title_size);

        (void) sprintf(nn, "%s.OutputAxisFont",  hard_devices[idx].dev_name);
        CHANGE_S(nn, dev_axis_font);

        (void) sprintf(nn, "%s.OutputAxisSize",  hard_devices[idx].dev_name);
        CHANGE_D(nn, dev_axis_size);

        if (hard_devices[idx].dev_printer[0] == '$') {
            char *ptr;
            if ((ptr = getenv(&hard_devices[idx].dev_printer[1]))) {
                (void) strncpy(hard_devices[idx].dev_printer, ptr, MFNAME - 1);
                hard_devices[idx].dev_printer[MFNAME - 1] = '\0';
            }
        }

        /* use the ( ifn-th ) input file name as base for output file names */

        ifn = 0;

        if ( make_otpnam(ifn, idx, lfn, filnam) ) { 
            strncpy(hard_devices[idx].dev_file, filnam, lfn);
        }
    }
}


/*****************/
/*  make_otpnam  */
/*****************/

int  make_otpnam( int   ifn    ,  /* index of input  file name  */
                  int   ityp   ,  /* index of output file type  */
                  int   lfn    ,  /* maximum length of filnam[] */
                  char *filnam )  /* desired output file name   */

/*
 * Makes an output device file name using the ( ifn )-th
 * input file name as a root base, stripping off the 
 * input file name extension (if any ).  ( ityp )
 * defines the output device index for the output file
 * name extension ( see hd_name_extn[] ).
 *
 * fatal errors, return = 0;  else = 1;
 */
{
    char   *ptr;

    int     i   = ifn;
    int     lng = lfn - 4;
    int     ok  = 1;

    if (lng < 1) {
      do_error("make_otpnam(): output file name string length < 5 -> error\n");
      filnam[0] = '\0';
      return (0);
    }

    strncpy(filnam, "xgraph", lng);  /* default output file name base */

    if (numFiles == 0) {
      do_error("make_otpnam(): no imput file names -> error\n");
    }
    else {
      if ((ifn < 0) || (ifn >= numFiles)) {
        do_error("make_otpnam(): desired input file name index out-of-range -> error\n");
        i = 0;
      }
      if (strlen(inFileNames[i]) <= 0) {
        do_error("make_otpnam(): input file name has zero length -> error\n");
      }
      else {
        strncpy(filnam, inFileNames[i], lng);
      }
    }

    /* extract input file name extention from anme */

    ptr = strrchr(filnam, '.');
    if (ptr != (char *)NULL) {
      ptr[0] = '\0';
    }

    /* add extension for output file type ( ityp ) */

    strcat(filnam, hd_name_extn[ityp]);
 
    return(1);
}
