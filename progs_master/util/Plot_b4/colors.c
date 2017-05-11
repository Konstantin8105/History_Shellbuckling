
/*
newclr: Sets the current color to "color".  See the DISSPLA color chart
for a valid list of color names.  newclr sets the three parameters, hue,
saturation, and intensity, of the static struct "color".
*/
void newclr_(char *lcolor, _int_ llcolor)
{
_int_ i;
char s[80];

  if (level < 1 || level > 3) {
    derror("Level must be 1, 2, or 3.  Routine: newclr", !FATAL);
    return;
  }

/* Check to make sure lcolor is a valid
   alpha data of four or fewer characters.
*/
  if (llcolor > 4) {
    derror("lcolor wrong length.  Color remains unchanged.", !FATAL);
    return;
  }

  for (i=0; i < llcolor; i++)
    if (isalpha(lcolor[i])) {
      if (islower(lcolor[i]))
	lcolor[i] = toupper(lcolor[i]);
    }
    else {
      derror("lcolor not character data.  Color remains unchanged.", !FATAL);
      return;
    };

  *s = '\0';

/* Assign color values according to lcolor. */
  if ((*lcolor == 'A') || (*lcolor == 'B'))

    if (!strcmp(lcolor, "AVOC"))
      set_color(0.25, 0.7, 0.65);
    else if (!strcmp(lcolor, "BACK"))
      set_color(1.0, 0.0, 1.0);
    else if (!strcmp(lcolor, "BEIG"))
      set_color(0.1, 0.45, 0.85);
    else if (!strcmp(lcolor, "BHGR"))
      set_color(0.417, 0.8, 0.8);
    else if (!strcmp(lcolor, "BHPU"))
      set_color(0.792, 0.8, 0.8);
    else if (!strcmp(lcolor, "BLAC"))
      set_color(0.667, 0.0, 0.0);
    else if (!strcmp(lcolor, "BLGR"))
      set_color(0.5, 0.8, 0.8);
    else if (!strcmp(lcolor, "BLPU"))
      set_color(0.75, 0.8, 0.8);
    else if (!strcmp(lcolor, "BLUE"))
      set_color(0.667, 1.0, 1.0);
    else if (!strcmp(lcolor, "BRIC"))
      set_color(0.033, 0.95, 0.6);
    else if (!strcmp(lcolor, "BROW"))
      set_color(0.043, 1.0, 0.407);
    else if (!strcmp(lcolor, "BURG"))
      set_color(0.933, 1.0, 0.5);
    else {
      strcat(s, "The color ");
      strcat(s, lcolor);
      strcat(s, " is not supported.  Color remains unchanged.");
      derror(s, !FATAL);
      return;
    }

  else if ((*lcolor >= 'C') && (*lcolor <= 'F'))

    if (!strcmp(lcolor, "CHAR"))
      set_color(1.0, 0.0, 0.3);
    else if (!strcmp(lcolor, "CHES"))
      set_color(0.02, 1.0, 0.32);
    else if (!strcmp(lcolor, "CORA"))
      set_color(0.033, 0.75, 0.9);
    else if (!strcmp(lcolor, "CREA"))
      set_color(0.1, 0.33, 1.0);
    else if (!strcmp(lcolor, "CYAN"))
      set_color(0.5, 0.8, 0.8);
    else if (!strcmp(lcolor, "EVER"))
      set_color(0.433, 1.0, 0.45);
    else if (!strcmp(lcolor, "FORE"))
      set_color(0.667, 0.0, 0.0);
    else {
      strcat(s, "The color ");
      strcat(s, lcolor);
      strcat(s, " is not supported.  Color remains unchanged.");
      derror(s, !FATAL);
      return;
    }
       
  else if ((*lcolor >= 'G') && (*lcolor <= 'K'))

    if (!strcmp(lcolor, "GHBL"))
      set_color(0.583, 0.8, 0.8);
    else if (!strcmp(lcolor, "GHYE"))
      set_color(0.208, 0.8, 0.8);
    else if (!strcmp(lcolor, "GOLD"))
      set_color(0.11, 0.9, 0.75);
    else if (!strcmp(lcolor, "GRAY"))
      set_color(1.0, 0.0, 0.5);
    else if (!strcmp(lcolor, "GRBL"))
      set_color(0.5, 0.8, 0.8);
    else if (!strcmp(lcolor, "GREE"))
      set_color(0.333, 1.0, 0.9);
    else if (!strcmp(lcolor, "GREY"))
      set_color(1.0, 0.0, 0.5);
    else if (!strcmp(lcolor, "GRYE"))
      set_color(0.25, 0.8, 0.8);
    else if (!strcmp(lcolor, "KELL"))
      set_color(0.4, 1.0, 0.55);
    else if (!strcmp(lcolor, "KHAK"))
      set_color(0.1, 0.5, 0.58);
    else {
      strcat(s, "The color ");
      strcat(s, lcolor);
      strcat(s, " is not supported.  Color remains unchanged.");
      derror(s, !FATAL);
      return;
    }

  else if ((*lcolor >= 'L') && (*lcolor <= 'O'))

    if (!strcmp(lcolor, "LAVE"))
      set_color(0.739, 0.567, 0.94);
    else if (!strcmp(lcolor, "MAGE"))
      set_color(0.833, 0.8, 0.8);
    else if (!strcmp(lcolor, "MUST"))
      set_color(0.1, 1.0, 0.6);
    else if (!strcmp(lcolor, "NAVY"))
      set_color(0.667, 1.0, 0.4);
    else if (!strcmp(lcolor, "OCHE") || !strcmp(lcolor, "OCHR"))
      set_color(0.097, 0.9, 0.68);
    else if (!strcmp(lcolor, "ORAN"))
      set_color(0.083, 1.0, 1.0);
    else if (!strcmp(lcolor, "OHRE"))
      set_color(0.02083, 0.8, 0.8);
    else if (!strcmp(lcolor, "OHYE"))
      set_color(0.14583, 0.8, 0.8);
    else if (!strcmp(lcolor, "OLIV"))
      set_color(0.21587, 1.0, 0.3765);
    else if (!strcmp(lcolor, "ORRE"))
      set_color(0.0417, 0.8, 0.8);
    else if (!strcmp(lcolor, "ORYE"))
      set_color(0.125, 0.8, 0.8);
    else {
      strcat(s, "The color ");
      strcat(s, lcolor);
      strcat(s, " is not supported.  Color remains unchanged.");
      derror(s, !FATAL);
      return;
    }

  else if ((*lcolor >= 'P') && (*lcolor <= 'R'))

    if (!strcmp(lcolor, "PEAC"))
      set_color(0.045, 0.597, 0.94);
    else if (!strcmp(lcolor, "PHBL"))
      set_color(0.7083, 0.8, 0.8);
    else if (!strcmp(lcolor, "PHRE"))
      set_color(0.9417, 0.8, 0.8);
    else if (!strcmp(lcolor, "PINK"))
      set_color(0.967, 0.6, 0.9);
    else if (!strcmp(lcolor, "PUBL"))
      set_color(0.75, 0.8, 0.8);
    else if (!strcmp(lcolor, "PURE"))
      set_color(0.917, 0.8, 0.8);
    else if (!strcmp(lcolor, "PURP"))
      set_color(0.833, 0.8, 0.8);
    else if (!strcmp(lcolor, "RED"))
/*
      set_color(0.0, 0.8, 0.8);
*/
      set_color(0.0, 1.0, 1.0);
    else if (!strcmp(lcolor, "REOR"))
      set_color(0.0417, 0.8, 0.8);
    else if (!strcmp(lcolor, "REPU"))
      set_color(0.917, 0.8, 0.8);
    else if (!strcmp(lcolor, "RHPU"))
      set_color(0.875, 0.8, 0.8);
    else if (!strcmp(lcolor, "RHOR"))
      set_color(0.0625, 0.8, 0.8);
    else if (!strcmp(lcolor, "ROSE"))
      set_color(0.933, 0.7, 0.8);
    else if (!strcmp(lcolor, "RUST"))
      set_color(0.06, 1.0, 0.7);
    else {
      strcat(s, "The color ");
      strcat(s, lcolor);
      strcat(s, " is not supported.  Color remains unchanged.");
      derror(s, !FATAL);
      return;
    }

  else /* if (*lcolor >= 'S') */

    if (!strcmp(lcolor, "SKY"))
      set_color(0.6, 0.55, 1.0);
    else if (!strcmp(lcolor, "TAN"))
      set_color(0.1, 0.5, 0.4);
    else if (!strcmp(lcolor, "TANG"))
      set_color(0.0813, 1.0, 0.8784);
    else if (!strcmp(lcolor, "TURQ"))
      set_color(0.463, 0.846, 0.7216);
    else if (!strcmp(lcolor, "VIOL"))
      set_color(0.767, 0.9, 0.7);
    else if (!strcmp(lcolor, "WHIT"))
      set_color(1.0, 0.0, 1.0);
    else if (!strcmp(lcolor, "YEGR"))
      set_color(0.25, 0.8, 0.8);
    else if (!strcmp(lcolor, "YELL"))
      set_color(0.167, 1.0, 0.9);
    else if (!strcmp(lcolor, "YEOR"))
      set_color(0.125, 0.8, 0.8);
    else if (!strcmp(lcolor, "YHGR"))
      set_color(0.2917, 0.8, 0.8);
    else if (!strcmp(lcolor, "YHOR"))
      set_color(0.10417, 0.8, 0.8);
    else {
      strcat(s, "The color ");
      strcat(s, lcolor);
      strcat(s, " is not supported.  Color remains unchanged.");
      derror(s, !FATAL);
      return;
    }
  ;
}

/*
set_color: sets the static color struct to the three values: hue, saturation,
and intensity.  This routine is primarily a space-saving device for the
source code.

Arguments:  
	h - hue, input value
        s - saturation, input value
        b - brightness or intensity, input value
*/
void set_color(_float_ h, _float_ s, _float_ b)
{
  color.hue = h;
  color.saturation = s;
  color.intensity = b;
}

/*
returnAutoTraceColor:  returns the color of the next trace and/or marker drawn
depending on the trace number.

Argument:	tracenum - the trace number to be drawn next, input
*/
char *returnAutoTraceColor(_int_ tracenum)
{
static char s[5];

  *s = '\0';
  switch (tracenum % MaxLeg) {
    case 0:
      strcpy(s, "RED");
      break;
    case 1:
      strcpy(s, "GREE");
      break;
    case 2:
      strcpy(s, "BLUE");
      break;
    case 3:
      strcpy(s, "CHES");
      break;
    case 4:
      strcpy(s, "RHPU");
      break;
    case 5:
      strcpy(s, "MUST");
      break;
    case 6:
      strcpy(s, "OLIV");
      break;
    case 7:
      strcpy(s, "ORRE");
      break;
    case 8:
      strcpy(s, "TURQ");
      break;
    case 9:
      strcpy(s, "PINK");
      break;
    case 10:
      strcpy(s, "VIOL");
      break;
    case 11:
      strcpy(s, "TANG");
      break;
    case 12:
      strcpy(s, "EVER");
      break;
    case 13:
      strcpy(s, "NAVY");
      break;
    case 14:
      strcpy(s, "PURE");
      break;
    case 15:
      strcpy(s, "YELL");
      break;
    case 16:
      strcpy(s, "AVOC");
      break;
    case 17:
      strcpy(s, "GHBL");
      break;
    case 18:
      strcpy(s, "BLPU");
      break;
    default:
      derror("Unable to return color.  routine: returnAutoTraceColor", !FATAL);
      *s = '\0';
  };
  return(s);
}

/*
setTraceColor: sets the color of trace to color.
*/

void setTraceColor(_int_ trace, char *color)
{
  newclr_(color, strlen(color));
  strcpy(plot.color[trace], color);
}
