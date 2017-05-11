
/*
 * Xgraph Dialog Boxes
 *
 * This file constructs the hardcopy and error dialog
 * boxes used by xgraph.  It uses the mini-toolbox
 * given in xtb.c.
 *
 */

#include "aparms.h"

#ifndef SHADOW
#define SHADOW
#endif

#define MAXCHBUF	1024

#define D_VPAD       	2
#define D_HPAD	        2
#define D_INT	        4
#define D_BRDR	        2
#define D_INP	        35
#define D_DSP	        10
#define D_FS	        10

struct d_info_orig {
    char    *prog;		/* Program name              */
    xtb_data cookie;		/* Info used by do_harcopy   */
    Window   choices;		/* Output device choices     */
    Window   fod;		/* File or device flag       */
    Window   fodspec;		/* File or device spec       */
    Window   docu_p;		/* Document predicate        */
    Window   dimspec;		/* Maximum dimension spec    */
    Window   outfmt;		/* Output format choices     */
    Window   tf_family;		/* Title font family spec    */
    Window   tf_size;		/* Title font size spec      */
    Window   af_family;		/* Axis font family spec     */
    Window   af_size;		/* Axis font size spec       */
};

#define	BACKSPACE	0010
#define DELETE		0177
#define CONTROL_U	0025
#define CONTROL_X	0030



/************/
/*  df_fun  */
/************/

xtb_hret  df_fun( Window   win   ,  /* Widget window   */
                  int      ch    ,  /* Typed character */
                  char     *text ,  /* Copy of text    */
                  xtb_data val   )  /* User info       */


/*
 * This is the handler function for the text widget for
 * specifing the file or device name.  It supports simple
 * line editing operations.
 */
{
    if ((ch == BACKSPACE) || (ch == DELETE)) {
	if (!xtb_ti_dch(win))
	    XBell(disp, 0);
    }
    else if ((ch == CONTROL_U) || (ch == CONTROL_X)) {
	(void) xtb_ti_set(win, "", (xtb_data)0);
    }
    else {
	/* Insert if printable - ascii dependent */
	if ((ch < ' ') || (ch >= DELETE) || !xtb_ti_ins(win, ch)) {
	    XBell(disp, 0);
	}
    }
    return XTB_HANDLED;
}


/************/
/*  ok_fun  */
/************/

xtb_hret  ok_fun( Window   win  ,  /* Button window     */
                  int      bval ,  /* Button value      */
                  xtb_data info )  /* Local button info */

/*
 * This is the handler function for when the `Ok' button
 * is hit.  It sets the button,  does the hardcopy output,
 * and turns the button off.  It returns a status which
 * deactivates the dialog.
 */
{
    d_info *real_info = (d_info *)info;
    int     val,
            dev_p,
            doc_p,
            f_or_a;
    char    file_or_dev[MAXCHBUF],
            dim_spec[MAXCHBUF],
           *dev_spec;
    char    tfam[MAXCHBUF],
            afam[MAXCHBUF];
    char    tsizstr[MAXCHBUF],
            asizstr[MAXCHBUF];
    double  max_dim,
            max_dev,
            max_w,
            max_h,
            tsize,
            asize;
    xtb_hret rtn;

    (void) xtb_bt_set(win, 1, (xtb_data)0, 0);

    val = xtb_br_get(real_info->choices);

    if ((val >= 0) && (val < hard_count)) {

	dev_p = xtb_br_get(real_info->fod);

	if ((dev_p == 0) || (dev_p == 1)) {

	    xtb_ti_get(real_info->fodspec, file_or_dev, (xtb_data *) 0);
	    doc_p = xtb_bt_get(real_info->docu_p, (xtb_data *) 0, (int *) 0);

            f_or_a = xtb_br_get(real_info->outfmt);

	    xtb_ti_get(real_info->dimspec, dim_spec, (xtb_data *) 0);
	    if (sscanf(dim_spec, "%lf", &max_dim) == 1) {

		xtb_ti_get(real_info->tf_family, tfam,    (xtb_data *) 0);
		xtb_ti_get(real_info->af_family, afam,    (xtb_data *) 0);
		xtb_ti_get(real_info->tf_size,   tsizstr, (xtb_data *) 0);

		if (sscanf(tsizstr, "%lf", &tsize) == 1) {

		    xtb_ti_get(real_info->af_size, asizstr, (xtb_data *) 0);

		    if (sscanf(asizstr, "%lf", &asize) == 1) {

			/* Got all the info */
			if (dev_p) {
			    dev_spec = (char *) 0;
			}
			else {
			    dev_spec = hard_devices[val].dev_spec;
			}

                        max_w   = hard_devices[val].dev_max_width;
                        max_h   = hard_devices[val].dev_max_height;
                        max_h   = max_h  > 0.0   ? max_h   : max_w;
                        max_dev = max_w  > max_h ? max_w   : max_h;
                        max_dim = max_dim > 0.0  ? max_dim : max_dev;
			max_w   = max_w * max_dim / max_dev;
			max_h   = max_h * max_dim / max_dev;

			do_hardcopy(val,
                                    real_info->prog,
                                    real_info->cookie,
				    hard_devices[val].dev_init,
                                    dev_spec,
				    file_or_dev,
                                    max_w,
                                    max_h,
				    tfam,
                                    tsize,
                                    afam,
                                    asize,
                                    doc_p,
                                    f_or_a);

			rtn = XTB_STOP;
		    }
		    else {

			/* Bad axis size */
			do_error("Bad axis font size\n");
			rtn = XTB_HANDLED;
		    }
		}
		else {

		    /* Bad title size */
		    do_error("Bad title font size\n");
		    rtn = XTB_HANDLED;
		}
	    }
	    else {

		/* Bad max dimension */
		do_error("Bad maximum dimension\n");
		rtn = XTB_HANDLED;
	    }
	}
	else {

	    /* Bad device spec */
	    do_error("Must specify `To File' or `To Device'\n");
	    rtn = XTB_HANDLED;
	}
    }
    else {

	/* Bad value spec */
	do_error("Must specify an output device\n");
	rtn = XTB_HANDLED;

    }

    (void) xtb_bt_set(win, 0, (xtb_data)0, 0);

    return rtn;
}


/*************/
/*  can_fun  */
/*************/

xtb_hret  can_fun( Window   win  ,  /* Button window     */
                   int      val  ,  /* Button value      */
                   xtb_data info )  /* Local button info */

/*
 * This is the handler function for the cancel button.  It
 * turns itself on and off and then exits with a status
 * which kills the dialog.
 */
{
    (void) xtb_bt_set(win, 1, (xtb_data)0, 0);
    (void) xtb_bt_set(win, 0, (xtb_data)0, 0);
    return XTB_STOP;
}



/**************/
/*  docu_fun  */
/**************/

xtb_hret  docu_fun( Window   win  ,  /* Button window     */
                    int      val  ,  /* Button value      */
                    xtb_data info )  /* Local button info */

/*
 * This is the handler function for the document button.  It
 * toggles it's state.
 */
{
    int     state;

    state = xtb_bt_get(win, (xtb_data *)0, (int *) 0);
    xtb_bt_set(win, (state == 0), (xtb_data)0, 0);
    return XTB_HANDLED;
}


/**************/
/*  ofmt_fun  */
/**************/

xtb_hret  ofmt_fun( Window   win  ,  /* Button row window */
                    int      old  ,  /* Previous button   */
                    int      new  ,  /* Current button    */
                    xtb_data info )  /* User data         */

/*
 * This routine swaps the default output format type based
 * on the state of the 'fit to page' or 'keep aspect' buttons.
 */
{
    d_info    *data = (d_info *)info;
    char       text[12];
    int        which_one;
    static int fmt_active[2] = { 0, 0 };;

    which_one = xtb_br_get(data->outfmt);

    //printf("ofmt_fun():  which_one = %d  old= %d  new= %d\n", which_one, old, new);

    return XTB_HANDLED;
}

/*************/
/*  dev_fun  */
/*************/

xtb_hret  dev_fun( Window   win  ,  /* Button row window */
                   int      old  ,  /* Previous button   */
                   int      new  ,  /* Current button    */
                   xtb_data info )  /* User data         */

/*
 * This routine swaps the device specific information
 * in the dialog based on what device is selected.  The
 * information passed is the information for the whole
 * dialog.
 */
{
    d_info *data = (d_info *)info;
    char    text[MAXCHBUF];
    int     fod_spot,
            inactive;
    double  max_dim,
            max_dev,
            max_w,
            max_h;

    fod_spot = xtb_br_get(data->fod);

    if ((old >= 0) && (old < hard_count)) {

	/* device or file name */

	xtb_ti_get(data->fodspec, text, (xtb_data *) 0);

	if      (fod_spot == 1) {
	    strncpy(hard_devices[old].dev_file,    text, MFNAME - 1);
	}
	else if (fod_spot == 0) {
	    strncpy(hard_devices[old].dev_printer, text, MFNAME - 1);
	}

        /* include in Document */

	if (xtb_bt_get(data->docu_p, (xtb_data *) 0, &inactive)) {
	    if (inactive)
		hard_devices[old].dev_docu = NONE;
	    else
		hard_devices[old].dev_docu = YES;
	}
	else if (inactive)
	    hard_devices[old].dev_docu = NONE;
	else
	    hard_devices[old].dev_docu = NO;

        /* maximum Dimension */

	xtb_ti_get(data->dimspec, text, (xtb_data *) 0);
	if (sscanf(text, "%lf", &max_dim) != 1) {
	    do_error("Warning: can't read maximum dimension");
	}
        else {
	  if (max_dim > 0.0) {
              max_w   = hard_devices[old].dev_max_width;
              max_h   = hard_devices[old].dev_max_height;
              max_h   = max_h  >   0.0 ? max_h : max_w;
              max_dev = max_w  > max_h ? max_w : max_h;

	      hard_devices[old].dev_max_width  = max_w * max_dim / max_dev;
	      hard_devices[old].dev_max_height = max_h * max_dim / max_dev;
	  }
        }

        /* title font specs */

	xtb_ti_get(data->tf_family, text, (xtb_data *) 0);
	strncpy(hard_devices[old].dev_title_font, text, MFNAME - 1);

	xtb_ti_get(data->tf_size, text, (xtb_data *) 0);
	if (sscanf(text, "%lf", &hard_devices[old].dev_title_size) != 1) {
	    do_error("Warning: can't read title font size");
	}

        /* axis font specs */

	xtb_ti_get(data->af_family, text, (xtb_data *) 0);
	strncpy(hard_devices[old].dev_axis_font, text, MFNAME - 1);

	xtb_ti_get(data->af_size, text, (xtb_data *) 0);
	if (sscanf(text, "%lf", &hard_devices[old].dev_axis_size) != 1) {
	    do_error("Warning: can't read axis font size");
	}
    }

    /* Insert new info */

    if ((new >= 0) && (new < hard_count)) {
	if (fod_spot == 1) {
	    xtb_ti_set(data->fodspec, hard_devices[new].dev_file, (xtb_data)0);
	}
	else if (fod_spot == 0) {
	    xtb_ti_set(data->fodspec, hard_devices[new].dev_printer,
		       (xtb_data)0);
	}
	else {
	    xtb_ti_set(data->fodspec, "", (xtb_data)0);
	}
	switch (hard_devices[new].dev_docu) {
	  case NONE:
	    (void) xtb_bt_set(data->docu_p, 0, (xtb_data)0, 1);
	    break;
	  case NO:
	    (void) xtb_bt_set(data->docu_p, 0, (xtb_data)0, 0);
	    break;
	  case YES:
	    (void) xtb_bt_set(data->docu_p, 1, (xtb_data)0, 0);
	    break;
	}

        max_w   = hard_devices[new].dev_max_width;
        max_h   = hard_devices[new].dev_max_height;
        max_dev = max_w > max_h ? max_w : max_h;

	(void) sprintf(text, "%lg", max_dev);
	xtb_ti_set(data->dimspec, text, (xtb_data)0);

	xtb_ti_set(data->tf_family, hard_devices[new].dev_title_font,
		   (xtb_data)0);
	(void) sprintf(text, "%lg", hard_devices[new].dev_title_size);
	xtb_ti_set(data->tf_size, text, (xtb_data)0);
	xtb_ti_set(data->af_family, hard_devices[new].dev_axis_font,
		   (xtb_data)0);
	(void) sprintf(text, "%lg", hard_devices[new].dev_axis_size);
	xtb_ti_set(data->af_size, text, (xtb_data)0);
    }
    return XTB_HANDLED;
}


/************/
/*  fd_fun  */
/************/

xtb_hret  fd_fun( Window   win  ,  /* Button row window */
                  int      old  ,  /* Previous button   */
                  int      new  ,  /* Current button    */
                  xtb_data info )  /* User data         */

/*
 * This routine swaps the default file or device names
 * based on the state of the file or device buttons.
 * The information passed is the information for the whole
 * dialog.
 */
{
    d_info *data = (d_info *) info;
    char    text[MAXCHBUF];
    int     which_one;

    which_one = xtb_br_get(data->choices);

    if ((which_one >= 0) && (which_one < hard_count)) {

	if      (old == 0) {
	    /* Save into device space */
	    xtb_ti_get(data->fodspec, text, (xtb_data *) 0);
	    strncpy(hard_devices[which_one].dev_printer, text, MFNAME - 1);
	}
	else if (old == 1) {
	    /* Save into file space */
	    xtb_ti_get(data->fodspec, text, (xtb_data *) 0);
	    which_one = xtb_br_get(data->choices);
	    strncpy(hard_devices[which_one].dev_file, text, MFNAME - 1);
	}

	if      (new == 0) {
	    /* Restore into device */
	    xtb_ti_set(data->fodspec, hard_devices[which_one].dev_printer,
		       (xtb_data *) 0);
	}
	else if (new == 1) {
	    /* Restore into file */
	    xtb_ti_set(data->fodspec, hard_devices[which_one].dev_file,
		       (xtb_data *) 0);
	}

    }
    return XTB_HANDLED;
}


/* Indices for frames made in make_dialog */

enum d_frames_defn {
    TITLE_F,
    ODEVLBL_F,
    ODEVROW_F,
    DISPLBL_F,
    DISPROW_F,
    FDLBL_F,
    FDINP_F,
    OPTLBL_F,
    DOCU_F,
    MDIMLBL_F,
    MDIMI_F,
    OFMTLBL_F,
    OFMTROW_F,
    TFLBL_F,
    TFFAMLBL_F,
    TFFAM_F,
    TFSIZLBL_F,
    TFSIZ_F,
    AFLBL_F,
    AFFAMLBL_F,
    AFFAM_F,
    AFSIZLBL_F,
    AFSIZ_F,
    OK_F,
    CAN_F,
    BAR_F,
    LAST_F
} d_frames;

#define AF(ix)	af[(int) (ix)]

#define BAR_SLACK	10


/*****************/
/*  make_dialog  */
/*****************/

void  make_dialog( Window    win     ,  /* Parent window          */
                   Window    spawned ,  /* Spawned from window    */
                   char      *prog   ,  /* Program name           */
                   xtb_data  cookie  ,  /* Info for do_hardcopy  */
                   xtb_frame *okbtn  ,  /* Frame for OK button    */
                   xtb_frame *frame  )  /* Returned window/size   */

/*
 * This routine constructs a new dialog for asking the user about
 * hardcopy devices.  The dialog and its size is returned in
 * `frame'.  The window of the `ok' button is returned in `btnwin'.
 * This can be used to reset some of the button state to reuse the dialog.
 */
{
    Window    overall;
    xtb_frame AF(LAST_F);

    xtb_fmt *def,
            *cntrl,
            *mindim,
            *outfm,
            *tfarea,
            *afarea,
            *finish,
            *allwin;
    Cursor   diag_cursor;
    XColor   fg_color,
             bg_color;
    XSizeHints           hints;
    unsigned long        wamask;
    XSetWindowAttributes wattr;
    d_info  *info;
    int      i,
             lng,
             found,
             max_width,
             which_one,
             fodi;

    /* ============================================================ */
    /* CAUTION - the maximum size for the different button rows are */
    /*           HARD CODED here, and must be changed if the number */
    /*           of buttons for any frame-row changes!              */
    /* ============================================================ */

    char    *outnam[4];
    char    *fodnam[2];
    char    *fmtnam[2];

    xtb_fmt *xtb_0         = (xtb_fmt *)0;

    static char *fodstrs[] = {"To Device",
                              "To File"};
    static char *fmtstrs[] = {"Fit To Page",
                              "Keep Aspect"};
    XFontStruct *bigFont   = PM_FONT("TitleFont");
    XFontStruct *medFont   = PM_FONT("LabelFont");

    char        *Odevice   = PM_STR("Device");
    char        *Odisp     = PM_STR("Disposition");
    char        *OfileDev  = PM_STR("FileOrDev");
    char        *Oformat   = PM_STR("OutputFmt");

    wamask = CWBackPixel | CWBorderPixel | CWOverrideRedirect |
	     CWSaveUnder | CWColormap;

    wattr.background_pixel  = PM_PIXEL("Background");
    wattr.background_pixel  = xtb_bg;
    wattr.border_pixel      = PM_PIXEL("Border");
    wattr.border_pixel      = xtb_bd;
    wattr.override_redirect = True;
    wattr.save_under        = True;
    wattr.colormap          = cmap;

    overall = XCreateWindow(disp, win, 0, 0, 1, 1, D_BRDR,
			    depth, InputOutput, vis,
			    wamask, &wattr);

    frame->win    = overall;
    frame->width  = 0;
    frame->height = 0;
    frame->x_loc  = 0;
    frame->y_loc  = 0;

    XStoreName(disp, overall, "Hardcopy Dialog");
    XSetTransientForHint(disp, spawned, overall);

    info         = (d_info *) Malloc(sizeof(d_info));
    info->prog   = prog;
    info->cookie = cookie;

    /* make Title frame */
    /* ---------------- */
    xtb_to_new(overall, "Hardcopy Options", bigFont, &AF(TITLE_F));

    /* make Output Devices frame */
    /* ------------------------- */
    xtb_to_new(overall, "Output device:",   medFont, &AF(ODEVLBL_F));

    /* load output device names */
    found = -1;
    for (i = 0; i < hard_count; i++) {
        lng       = strlen(hard_devices[i].dev_name);
        outnam[i] = (char *) Malloc((unsigned) (sizeof(char) * (lng+3)));
        strcpy(outnam[i], " ");
        strcat(outnam[i], hard_devices[i].dev_name);
        strcat(outnam[i], " ");
	if (strcmp(Odevice, hard_devices[i].dev_name) == 0) found = i;
    }
    /* force initial display to have ( Postscript ) activated */
    found = 2;

    /* create row of buttons for hard_devices */
    xtb_br_new(overall, hard_count, outnam, found, dev_fun, (xtb_data)info, &AF(ODEVROW_F));
    info->choices = AF(ODEVROW_F).win;

    /* make File or Device frame */
    /* ------------------------- */
    xtb_to_new(overall, "Disposition:", medFont, &AF(DISPLBL_F));

    found = -1;
    for (i = 0; i < 2; i++) {
        lng       = strlen(fodstrs[i]);
        fodnam[i] = (char *) Malloc((unsigned) (sizeof(char) * (lng+3)));
        strcpy(fodnam[i], " ");
        strcat(fodnam[i], fodstrs[i]);
        strcat(fodnam[i], " ");
	if (strcmp(Odisp, fodstrs[i]) == 0) found = i;
    }

    /* FORCE initial display to have ( To File ) activated */
  //found = 1;  /* see ( DEF_DISPOSITION ) in init.c */

    /* create row of buttons for Device or File */
    xtb_br_new(overall, 2, fodnam, found, fd_fun, (xtb_data)info, &AF(DISPROW_F));
    info->fod = AF(DISPROW_F).win;

    /* make File or Device Name frame */
    /* ------------------------------ */
    xtb_to_new(overall, "File or Device Name:", medFont, &AF(FDLBL_F));

    xtb_ti_new(overall, "", D_INP, df_fun, (xtb_data)0, &AF(FDINP_F));

    if (OfileDev && strlen(OfileDev)) {
	which_one = xtb_br_get(info->choices);
	if ((which_one >= 0) && (which_one < hard_count)) {
	    fodi = xtb_br_get(info->fod);
	    if (fodi == 0) {
		strncpy(hard_devices[which_one].dev_printer, OfileDev, MFNAME - 1);
	    }
	    else if (fodi == 1) {
		strncpy(hard_devices[which_one].dev_file, OfileDev, MFNAME - 1);
	    }
	}
    }
    info->fodspec = AF(FDINP_F).win;

    /* =============================================================================== */

    /* make Optional Parameters frame */
    /* ------------------------------ */
     xtb_to_new(overall, "Optional Parameters", bigFont, &AF(OPTLBL_F));

    /* make Maximum Dimension frame */
    /* ---------------------------- */
    xtb_to_new(overall, "Maximum Dimension (cm):", medFont, &AF(MDIMLBL_F));

    xtb_ti_new(overall, "", D_DSP, df_fun, (xtb_data)0, &AF(MDIMI_F));
    info->dimspec = AF(MDIMI_F).win;

    /* make Include in Document frame */
    /* ------------------------------ */
    xtb_bt_new(overall, "Include in Document", docu_fun, (xtb_data)0, &AF(DOCU_F));
    info->docu_p = AF(DOCU_F).win;

    /* =============================================================================== */

    /* make Output Format frame */
    /* ------------------------ */
    xtb_to_new(overall, "Output format:", medFont, &AF(OFMTLBL_F));

    /* load output format names */
    found   = -1;
    for (i = 0; i < 2; i++) {
        lng       = strlen(fmtstrs[i]);
        fmtnam[i] = (char *) Malloc((unsigned) (sizeof(char) * (lng+3)));
        strcpy(fmtnam[i], " ");
        strcat(fmtnam[i], fmtstrs[i]);
        strcat(fmtnam[i], " ");
	if (strcmp(Odisp, fmtstrs[i]) == 0) found = i;
    }

    /* force initial format to have ( Fit To Page ) activated */
    found = 0;

    /* create row of buttons for output formats */
    xtb_br_new(overall, 2, fmtnam, found, ofmt_fun, (xtb_data)info, &AF(OFMTROW_F));
    info->outfmt = AF(OFMTROW_F).win;

    /* =============================================================================== */

    /* make Title Font Family frame */
    /* ---------------------------- */
    xtb_to_new(overall, "Title Font", medFont, &AF(TFLBL_F));
    xtb_to_new(overall, "Family:", medFont, &AF(TFFAMLBL_F));
    xtb_ti_new(overall, "", MFNAME, df_fun, (xtb_data)0, &AF(TFFAM_F));
    info->tf_family = AF(TFFAM_F).win;

    /* make Title Font Size frame */
    /* --------------------------- */
    xtb_to_new(overall, "Size (pnts):", medFont, &AF(TFSIZLBL_F));
    xtb_ti_new(overall, "", D_FS, df_fun, (xtb_data)0, &AF(TFSIZ_F));
    info->tf_size = AF(TFSIZ_F).win;

    /* make Axis Font Family frame */
    /* ----------------------------- */
    xtb_to_new(overall, "Axis Font", medFont, &AF(AFLBL_F));
    xtb_to_new(overall, "Family:", medFont, &AF(AFFAMLBL_F));
    xtb_ti_new(overall, "", MFNAME, df_fun, (xtb_data)0, &AF(AFFAM_F));
    info->af_family = AF(AFFAM_F).win;

    /* make Axis Font Size frame */
    /* -------------------------- */
    xtb_to_new(overall, "Size (pnts):", medFont, &AF(AFSIZLBL_F));
    xtb_ti_new(overall, "", D_FS, df_fun, (xtb_data)0, &AF(AFSIZ_F));
    info->af_size = AF(AFSIZ_F).win;

    /* make OK/Cancel frame */
    /* -------------------- */
    xtb_bt_new(overall, "  Ok  ", ok_fun,  (xtb_data)info, &AF(OK_F));
    xtb_bt_new(overall, "Cancel", can_fun, (xtb_data)0, &AF(CAN_F));

    /* =============================================================================== */

    /* make Dividing Bar frame */
    /* ----------------------- */
    max_width = 0;
    for (i = 0; i < ((int)BAR_F); i++) {
	if (AF(i).width > max_width)
	    max_width = AF(i).width;
    }

    xtb_bk_new(overall, max_width - BAR_SLACK, 1, &AF(BAR_F));


    /* =============================================================================== */

    /* Set device specific info */
    (void) dev_fun  (info->choices, -1, xtb_br_get(info->choices), (xtb_data)info);
    (void) fd_fun   (info->fod,     -1, xtb_br_get(info->fod),     (xtb_data)info);
    (void) ofmt_fun (info->outfmt,  -1, xtb_br_get(info->outfmt),  (xtb_data)info);

    /*
     * Now place elements - could make this one expression but pcc is too
     * wimpy.
     */

    cntrl = xtb_vert(XTB_LEFT, D_VPAD, D_INT,
		     xtb_hort(XTB_CENTER, D_HPAD, D_INT,
			      xtb_w(&AF(ODEVLBL_F)),
			      xtb_w(&AF(ODEVROW_F)),
                              xtb_0),
		     xtb_hort(XTB_CENTER, D_HPAD, D_INT,
			      xtb_w(&AF(DISPLBL_F)),
			      xtb_w(&AF(DISPROW_F)),
                              xtb_0),
		     xtb_hort(XTB_CENTER, D_HPAD, D_INT,
			      xtb_w(&AF(FDLBL_F)),
			      xtb_w(&AF(FDINP_F)),
                              xtb_0),
		     xtb_0);

    mindim = xtb_vert(XTB_LEFT, D_VPAD, D_INT,
		      xtb_hort(XTB_CENTER, D_HPAD, D_INT,
			       xtb_w(&AF(MDIMLBL_F)),
			       xtb_w(&AF(MDIMI_F)),
			       xtb_0),
		      xtb_0);

    outfm = xtb_vert(XTB_LEFT, D_VPAD, D_INT,
		     xtb_hort(XTB_CENTER, D_HPAD, D_INT,
			      xtb_w(&AF(OFMTLBL_F)),
			      xtb_w(&AF(OFMTROW_F)),
                              xtb_0),
		     xtb_0);

    tfarea = xtb_vert(XTB_LEFT, D_VPAD, D_INT,
		      xtb_hort(XTB_CENTER, D_HPAD, D_INT,
			       xtb_w(&AF(TFFAMLBL_F)),
			       xtb_w(&AF(TFFAM_F)),
			       xtb_w(&AF(TFSIZLBL_F)),
			       xtb_w(&AF(TFSIZ_F)),
                               xtb_0),
		      xtb_0);

    afarea = xtb_vert(XTB_LEFT, D_VPAD, D_INT,
		      xtb_hort(XTB_CENTER, D_HPAD, D_INT,
			       xtb_w(&AF(AFFAMLBL_F)),
			       xtb_w(&AF(AFFAM_F)),
			       xtb_w(&AF(AFSIZLBL_F)),
			       xtb_w(&AF(AFSIZ_F)),
                               xtb_0),
		      xtb_0);

    finish = xtb_hort(XTB_CENTER, D_HPAD, D_INT,
                      xtb_w(&AF(OK_F)),
                      xtb_w(&AF(CAN_F)),
                      xtb_0),

    allwin = xtb_vert(XTB_CENTER, D_VPAD, D_INT,
                      xtb_w(&AF(TITLE_F)),
		      cntrl,
		      xtb_w(&AF(BAR_F)),
		      xtb_w(&AF(OPTLBL_F)),
		      mindim,
		      xtb_w(&AF(DOCU_F)),
		      outfm,
		      xtb_w(&AF(TFLBL_F)),
		      tfarea,
		      xtb_w(&AF(AFLBL_F)),
		      afarea,
		      finish,
		      xtb_0);

    def = xtb_fmt_do(allwin,
	            &frame->width,
                    &frame->height);

    xtb_mv_frames(LAST_F, af);

    xtb_fmt_free(def);

    /* Make window large enough to contain the info */

    XResizeWindow(disp, overall, frame->width, frame->height);

    hints.flags  = PSize;
    hints.width  = frame->width;
    hints.height = frame->height;
    XSetNormalHints(disp, overall, &hints);

    diag_cursor    = XCreateFontCursor(disp, XC_dotbox);

    fg_color.pixel = PM_PIXEL("Foreground");
  //fg_color.pixel = 0x004169e1; // royal blue
    XQueryColor(disp, cmap, &fg_color);

    bg_color.pixel = PM_PIXEL("Background");
  //bg_color.pixel = 0x00ffff00; // yellow
    XQueryColor(disp, cmap, &bg_color);

    XRecolorCursor(disp, diag_cursor, &fg_color, &bg_color);

    XDefineCursor(disp, overall, diag_cursor);
    frame->width  += (2 * D_BRDR);
    frame->height += (2 * D_BRDR);
    *okbtn = AF(OK_F);
}



#ifdef SHADOW


/*****************/
/*  make_shadow  */
/*****************/

Window  make_shadow( int    width  , /* window width  */
                     int    height ) /* shadow color  */

/*
 * Makes a shadow window for a pop-up window of the specified size.
 */
{
    Window                shadow;
    unsigned long         bg_pixel;
    unsigned long         wmask;
    XSetWindowAttributes  xswa;
    XColor                color;

    /* first get color */

    get_color("royal blue", &color);

    if (color.pixel == 0) {
        color.pixel = 0x004169e1; // royal blue
    }

    /*
    bg_pixel               = 0x00ff0000; // red
    bg_pixel               = 0x0000ff00; // green
    bg_pixel               = 0x000000ff; // blue
    */

    wmask                  = CWBackPixel | CWBorderPixel | CWOverrideRedirect
                                         | CWSaveUnder   | CWColormap;

    xswa.background_pixel  = color.pixel;
    xswa.border_pixel      = color.pixel;
    xswa.override_redirect = True;
    xswa.save_under        = True;
    xswa.colormap          = cmap;

    shadow = XCreateWindow(disp, RootWindow(disp, screen), 0, 0, width, height, 0,
			   depth, InputOutput, vis, wmask, &xswa);

    return shadow;
}


#endif



#define SH_W	4
#define SH_H	4


/***************/
/*  ho_dialog  */
/***************/

void  ho_dialog( Window   parent ,  /* Parent window              */
                 char     *prog  ,  /* Program name               */
                 xtb_data cookie )  /* Info passed to do_hardcopy */

/*
 * Asks the user about hardcopy devices.  A table of hardcopy
 * device names and function pointers to their initialization
 * functions is assumed to be in the global `hard_devices' and
 * `hard_count'.  Returns a non-zero status if the dialog was
 * sucessfully posted.  Calls do_hardcopy in xgraph to actually
 * output information.
 */
{
#ifdef SHADOW
    static Window     shadow;

#endif
    static Window     dumi;
    static xtb_frame  overall = {(Window)0, 0, 0, 0, 0};
    static xtb_frame  okbtn;
    XEvent            evt;
    XWindowAttributes winInfo;
    XSizeHints        hints;
    d_info           *info;
    int               x_loc, y_loc;

    if (!overall.win) {
	make_dialog(RootWindow(disp, screen), parent, prog, cookie,
		    &okbtn, &overall);
    }
    else {
	/* Change the button information */
	(void) xtb_bt_get(okbtn.win, (xtb_data *)&info, (int *)0);
	info->prog   = prog;
	info->cookie = cookie;
    }

    XGetWindowAttributes(disp, parent, &winInfo);
    XTranslateCoordinates(disp, parent, RootWindow(disp, screen),
			  0, 0, &winInfo.x, &winInfo.y, &dumi);

    x_loc = (int)(winInfo.x + winInfo.width  / 2 - overall.width  / 2);
    y_loc = (int)(winInfo.y + winInfo.height / 2 - overall.height / 2);

    XMoveWindow(disp, overall.win, x_loc, y_loc);
    hints.flags = PPosition;
    hints.x     = x_loc;
    hints.y     = y_loc;
    XSetNormalHints(disp, overall.win, &hints);

#ifdef SHADOW
    shadow = make_shadow(overall.width, overall.height);

    x_loc += SH_W;
    y_loc += SH_H;

    XMoveWindow(disp, shadow, x_loc, y_loc);
    hints.flags = PPosition;
    hints.x     = x_loc;
    hints.y     = y_loc;
    XSetNormalHints(disp, shadow, &hints);

    XRaiseWindow(disp, shadow);
    XMapWindow(disp, shadow);
#endif

    XRaiseWindow(disp, overall.win);
    XMapWindow(disp, overall.win);
    do {
	XNextEvent(disp, &evt);
    } while (xtb_dispatch(&evt) != XTB_STOP);

    XUnmapWindow(disp, overall.win);
#ifdef SHADOW

    XUnmapWindow(disp, shadow);
#endif
}



/**************/
/*  err_func  */
/**************/

xtb_hret  err_func( Window   win  ,  /* Button window     */
                    int      bval ,  /* Button value      */
                    xtb_data info )  /* Local button info */

/*
 * Handler function for button in error box.  Simply stops dialog.
 */
{
    (void) xtb_bt_set(win, 1, (xtb_data)0, 0);
    (void) xtb_bt_set(win, 0, (xtb_data)0, 0);
    return XTB_STOP;
}


struct err_info {
    Window  title;
    Window  contbtn;
    int     num_lines;
    int     alloc_lines;
    Window *lines;
};

#define E_LINES	2
#define E_VPAD	3
#define E_HPAD	3
#define E_INTER	1
#define ML	256


/******************/
/*  make_msg_box  */
/******************/

void  make_msg_box( char      *text  ,  /* Error text    */
                    char      *title ,  /* Title text    */
                    xtb_frame *frame )  /* Returned frame */

/*
 * Makes an error box with a title.
 */
{
    XSizeHints hints;
    struct err_info *new_info;
    xtb_frame tf,
              cf,
              lf;
    char     *lineptr,
              line[ML];
    int       y,
              i;
    unsigned long         wamask;
    XSetWindowAttributes  wattr;
    XFontStruct          *bigFont = PM_FONT("TitleFont");
    XFontStruct          *medFont = PM_FONT("LabelFont");

    wamask                  = CWBackPixel | CWBorderPixel | CWOverrideRedirect
                                          | CWSaveUnder   | CWColormap;

    wattr.background_pixel  = PM_PIXEL("Background");
    wattr.background_pixel  = 0x00ffff00; // yellow
    wattr.border_pixel      = PM_PIXEL("Border");
    wattr.override_redirect = True;
    wattr.save_under        = True;
    wattr.colormap          = cmap;

    frame->win = XCreateWindow(disp, RootWindow(disp, screen), 0, 0, 1, 1, D_BRDR,
			       depth, InputOutput, vis, wamask, &wattr);

    frame->x_loc  = 0;
    frame->y_loc  = 0;
    frame->width  = 0;
    frame->height = 0;

    XStoreName(disp, frame->win, "Error Dialog");

    XSetTransientForHint(disp, RootWindow(disp, screen), frame->win);

    new_info = (struct err_info *) Malloc((unsigned) sizeof(struct err_info));

    xtb_to_new(frame->win, title, bigFont, &tf);
    new_info->title = tf.win;
    if (tf.width > frame->width)
	frame->width = tf.width;

    xtb_bt_new(frame->win, "Dismiss", err_func, (xtb_data)0, &cf);

    new_info->contbtn = cf.win;
    if (cf.width > frame->width)
	frame->width = cf.width;

    new_info->alloc_lines = E_LINES;
    new_info->num_lines = 0;
    new_info->lines = (Window *) Malloc((unsigned) (sizeof(Window) * E_LINES));
    /* zero the memory out of paranoia */
    memset(new_info->lines, 0, sizeof(Window) * E_LINES);

    lineptr = text;
    while (get_line(&lineptr, line)) {
	if (new_info->num_lines >= new_info->alloc_lines) {
	    int old_alloc_lines_size = new_info->alloc_lines * sizeof(Window);
	    new_info->alloc_lines *= 2;
	    new_info->lines = (Window *) Realloc((char *) new_info->lines,
						 (unsigned)
						 (new_info->alloc_lines *
						  sizeof(Window)));
            memset(((char*)new_info->lines) + old_alloc_lines_size,
		   0, old_alloc_lines_size);
	}
	xtb_to_new(frame->win, line, medFont, &lf);
	new_info->lines[new_info->num_lines] = lf.win;
	new_info->num_lines += 1;
	if (lf.width > frame->width)
	    frame->width = lf.width;
    }


    /* Placement */
    frame->width += (2 * E_HPAD);
    y = E_VPAD;
    /* Title */
    XMoveWindow(disp, new_info->title, (int) (frame->width / 2 - tf.width / 2), y);
    y += (tf.height + E_INTER);
    /* All lines */
    for (i = 0; i < new_info->num_lines; i++) {
	XMoveWindow(disp, new_info->lines[i], E_HPAD, y);
	y += (lf.height + E_INTER);
    }
    /* Button */
    XMoveWindow(disp, new_info->contbtn, (int) (frame->width / 2 - cf.width / 2), y);
    y += (cf.height + E_INTER);

    /* Make dialog the right size */
    y += (E_VPAD - E_INTER);
    XResizeWindow(disp, frame->win, frame->width, (unsigned int) y);
    hints.flags  = PSize;
    hints.width  = frame->width;
    hints.height = (unsigned int) y;
    XSetNormalHints(disp, frame->win, &hints);
    frame->width += (2 * D_BRDR);
    frame->height =  y + (2 * D_BRDR);
    xtb_register(frame->win, (xtb_hret(*) ()) 0, (xtb_data)new_info);
}


/*************/
/*  msg_box  */
/*************/

void  msg_box( char *title , 
               char *text  ) 

/*
 * This posts a dialog that contains lines of text and a continue
 * button.  The text may be multiple lines.  The dialog is remade
 * each time.
 */
{
#ifdef SHADOW
    Window            shadow;

#endif
    XEvent            evt;
    XSizeHints        hints;
    xtb_frame         par_frame;
    xtb_frame         msg_frame;
    int               x_min,  x_max, x_cen, x_loc;
    int               y_min,  y_max, y_cen, y_loc;
    int               bordr = 10;

    /* first, create a message box window */

    make_msg_box(text, title, &msg_frame);

    /* get the xgraph window location and sizing */

    par_frame.win = main_window;

    if ( Window_Geometry(&par_frame) == 0 ) {

      /* xgraph window doesn't yield its attributes ? */
      /* use the root window's attributes instead     */

      par_frame.win = RootWindow(disp, screen);

      Window_Geometry(&par_frame);
    }

    x_min = par_frame.x_loc;
    y_min = par_frame.y_loc;
    x_max = x_min + par_frame.width;
    y_max = y_min + par_frame.height;

    /* now the center where we want to display the message box */

    x_cen = (x_min + x_max) / 2;
    y_cen = (y_min + y_max) / 2;

    /* get the upper left corner of the message box window */

    x_loc  = x_cen - (msg_frame.width  / 2);
    y_loc  = y_cen - (msg_frame.height / 2);

    /* let's not let the user position the xgraph window such */
    /* that our message box window will partially fall off    */
    /* the screen! instead, we will readjust it appropriately */

    if (x_loc < 0) {
      x_loc = bordr;
      if (x_loc + msg_frame.width  > x_max) x_loc = 0;
    }

    if (y_loc < 0) {
      y_loc = bordr;
      if (y_loc + msg_frame.height > y_max) y_loc = 0;
    }

    /* OK, all set, let's move out message box window */

    XMoveWindow(disp, msg_frame.win, x_loc, y_loc);
    hints.flags = PPosition;
    hints.x     = x_loc;
    hints.y     = y_loc;
    XSetNormalHints(disp, msg_frame.win, &hints);

#ifdef SHADOW
    /* second, create a shadow window of the same size */
    /* ----------------------------------------------- */

    shadow = make_shadow(msg_frame.width, msg_frame.height);

    x_loc += SH_W;
    y_loc += SH_H;

    XMoveWindow(disp, shadow, x_loc, y_loc);
    hints.flags = PPosition;
    hints.x     = x_loc;
    hints.y     = y_loc;
    XSetNormalHints(disp, shadow, &hints);

    XRaiseWindow(disp, shadow);
    XMapWindow(disp, shadow);
#endif

    XRaiseWindow(disp, msg_frame.win);
    XMapWindow(disp, msg_frame.win);
    do {
	XNextEvent(disp, &evt);
    } while (xtb_dispatch(&evt) != XTB_STOP);
#ifdef SHADOW
    XDestroyWindow(disp, shadow);
#endif
    del_msg_box(msg_frame.win);
}


/**************/
/*  do_error  */
/**************/

void  do_error( char *err_text ) 
{
    if (PM_INT("Output Device") == D_XWINDOWS)
	msg_box("Xgraph Error", err_text);
    else
	fputs(err_text, stderr);
}



/**************/
/*  get_line  */
/**************/

int  get_line( char **tptr , 
               char *lptr  ) 

/*
 * Returns next line from tptr.  Assumes `lptr' is large enough to
 * accept the line.
 */
{
    char   *start;

    start = *tptr;
    while (*tptr && **tptr && (**tptr != '\n')) {
	(*tptr)++;
    }
    if (*tptr > start) {
	(void) strncpy(lptr, start, (*tptr - start));
	lptr[*tptr - start] = '\0';
	if (**tptr == '\n')
	    (*tptr)++;
	return 1;
    }
    else {
	return 0;
    }
}



/*****************/
/*  del_msg_box  */
/*****************/

void  del_msg_box( Window msg ) 

/*
 * Deletes all components of an msg box
 */
{
    struct err_info *info;
    char   *dummy;
    int     i;

    if (xtb_unregister(msg, (xtb_data *)&info)) {
	xtb_to_del(info->title);
	xtb_bt_del(info->contbtn, (xtb_data *) & dummy);
	for (i = 0; i < info->num_lines; i++) {
	    xtb_to_del(info->lines[i]);
	}
	Free((char *) info->lines);
	Free((char *) info);
	XDestroyWindow(disp, msg);
    }
}
